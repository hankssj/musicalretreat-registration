# == Schema Information
# Schema version: 20111124000001
#
# Table name: registrations
#
#  id                      :integer(4)      not null, primary key
#  year                    :string(255)     not null
#  user_id                 :integer(4)      not null
#  first_name              :string(255)
#  last_name               :string(255)
#  street1                 :string(255)
#  street2                 :string(255)
#  city                    :string(255)
#  state                   :string(255)
#  zip                     :string(255)
#  primaryphone            :string(255)
#  secondaryphone          :string(255)
#  emergency_contact_name  :string(255)
#  emergency_contact_phone :string(255)
#  firsttime               :boolean(1)
#  mailinglist             :boolean(1)      default(TRUE)
#  donotpublish            :boolean(1)
#  dorm                    :boolean(1)      default(TRUE)
#  share_housing_with      :string(255)
#  meals                   :boolean(1)      default(TRUE)
#  vegetarian              :boolean(1)
#  gender                  :string(255)     default("F")
#  participant             :boolean(1)      default(TRUE)
#  instrument_id           :integer(4)
#  monday                  :boolean(1)
#  tshirtm                 :integer(4)      default(0)
#  tshirtl                 :integer(4)      default(0)
#  tshirtxl                :integer(4)      default(0)
#  tshirtxxl               :integer(4)      default(0)
#  discount                :boolean(1)
#  donation                :integer(4)      default(0)
#  comments                :text
#  aircond                 :boolean(1)
#  payment_mode            :string(255)     default("deposit_check")
#  created_at              :datetime
#  updated_at              :datetime
#  country                 :string(255)     default("USA")
#  home_phone              :string(255)
#  cell_phone              :string(255)
#  work_phone              :string(255)
#

class Registration < ActiveRecord::Base

  belongs_to :user
  has_many :payments

  has_many :secondary_instruments
  has_many :instruments, :through => :secondary_instruments

  validates_presence_of :first_name, :last_name
  validates_numericality_of :donation
  
  def validate	
    if donation && donation < 0
      errors.add("Negative donation")
    end
    
    if participant && (instrument_id.nil? || instrument_id < 0)
      errors.add_to_base("Participants must select a primary instrument.")
    end

    
    [:home_phone, :work_phone, :cell_phone, :emergency_contact_phone].each do |p|
      errors.add_to_base("Error processing #{p}. Please use ten-digit phone number.  Put International phone number in Comments") \
      unless validate_phone(self.send(p))
    end
  end

  def validate_phone(p)
    p.empty? || p.gsub(/[^\d]/,"").length == 10
  end

  def instrument_name
    instrument_id ? Instrument.find(instrument_id).display_name : "None"
  end
  
  def display_name
    first_name + " " + last_name
  end

  ## for sorting
  def sort_name
    return last_name + " " + first_name
  end
  
  def email
    user_id && user.email
  end

  def contact_id
    user_id && user.contact_id
  end

  def registration_date
    created_at.to_date
  end
  
  def deposit_date
    if deposit == 0
      created_on.to_date
    elsif total_payments < deposit
      nil
    else
      payments.first.date_received
    end
  end
  
  def t_shirt_counts
    count = {}
    count[:S] = tshirts || 0
    count[:M] = tshirtm || 0
    count[:L] = tshirtl || 0
    count[:XL] = tshirtxl || 0
    count[:XXL] = tshirtxxl || 0
    count[:XXXL] = tshirtxxxl || 0
    count
  end
  
  def self.populate(user)
    reg = user.most_recent_registration
    new_reg = reg ? reg.clone : Registration.new
    new_reg.year = Year.this_year
    new_reg.user_id = user.id
    new_reg.firsttime = false
    new_reg.comments = ""
    new_reg
  end

  def board?
    user.board?
  end

  def staff?
    user.staff?
  end
  
  #  This constructs and populates a cart based on current values
  def cart(display_cc = false)
    c = Cart.new(self)

    tstotal = (tshirts || 0) + (tshirtm || 0) + (tshirtl || 0)+ (tshirtxl || 0) + 
      (tshirtxxl || 0) + (tshirtxxxl || 0)

    
    if staff? 
      tstotal = tstotal - 1
      tstotal = 0 if tstotal < 0
    elsif board? #  Board gets flat rate, with dorm rooms, sunday arrival and one T-shirt included
      c.set_quantity("Board Member Flat Rate", 1)
      tstotal = tstotal - 1
      tstotal = 0 if tstotal < 0
    else
      c.set_quantity("Registration", 1)
      c.set_quantity("Tuition", participant ? 1 : 0)
      c.set_quantity("Dorm", dorm ? 1 : 0)
      c.set_quantity("Meals", meals ? 1 : 0)
      c.set_quantity("Sunday Arrival", sunday ? 1 : 0)
    end

    #  Add-ons for everybody
    c.set_quantity("Tshirts", tstotal)
    c.set_quantity("Commemorative Wine Glass", wine_glasses)
    c.set_quantity("Single Room", single_room ? 1 : 0)

    if donation
      c.install_charge("Donation", donation)
    else
      c.set_quantity("Donation", 0)
    end

    c
  end	
  
  ###########################################
  ##  Payments, deposits and the like

  
  def total_payments
    total = 0
    payments.each {|payment| total += payment.amount}
    total
  end
  
  def total_charges
    cart.total
  end
  
  def balance
    total_charges - total_payments
  end
  
  def deposit_complete?
    deposit_balance <= 0
  end
  
  def deposit_balance
    standard_deposit = Charge.charge_for("Deposit")
    [[0, standard_deposit - total_payments].max, total_charges].min
  end

  def scholarship?
    payments.any?{|p|p.scholarship?}
  end

  def scholarship_amount
    payments.select{|p|p.scholarship?}.map{|p|p.amount}.inject(0){|s,n|s+n}
  end

  def non_scholarship_payment_total
    payments.select{|p|!p.scholarship?}.map{|p|p.amount}.inject(0){|s,x|s+x}
  end


  def cancel()
    fields = ["year", "user_id", "first_name", "last_name", "instrument_id"]
    c = Cancellation.new
    fields.each{|k| c.send("#{k}=", send(k))}
    c.registration_id = id
    c.save!
    payments.each{|p|p.cancel}
    destroy	
  end
  
  #################################################
  ##  Sorting
  
  class << self
    
    def nil_comparator(v1, v2)
      return 0 if v1.nil? && v2.nil?
      v1.nil? ? 1 : -1
    end
    
    def sort(registrations, column, direction)
      column = "sort_name" unless column
      direction = "asc" unless direction
      
      registrations.sort{|r1, r2| 
        rr1 = direction == "asc" ? r1 : r2
        rr2 = direction == "asc" ? r2 : r1
        
        #  No idea why this is necessary, but without it, we're getting
        #  a "no method" runtime error on these two fields (only).  For 
        #  some reason, forcing the load makes the error go away
        rr1.monday; rr1.firsttime;  rr2.monday;  rr2.firsttime
        #  end hack
        
        v1 = rr1.method(column).call
        v1 = 0 if v1.class == TrueClass
        v1 = 1 if v1.class == FalseClass
        v2 = rr2.method(column).call
        v2 = 0 if v2.class == TrueClass
        v2 = 1 if v2.class == FalseClass

        v1 = v1.upcase if v1.class == String
        v2 = v2.upcase if v2.class == String
        
        v1.nil? || v2.nil? ? nil_comparator(v1, v2) : v1 <=> v2
      }
    end
  end	

#####################################
##  These are for pass through to cc/depart, so they could be called either
##  after initial registration, or when returning to pay either deposit or 
##  balance. 
##  Balance is charges net of payment (displayed on cart)
##  Total is charges without deducting payment (passed through to cc controller)

  #  Deposit 
  def deposit  
    [Charge.charge_for("Deposit").to_f, balance].min
  end
  def payment_net; payment_mode =~ /deposit/ ? deposit : balance; end
  def credit_card_charge; Cart.cc_charge(payment_net); end

#######################################################################
## For dumping text file for export to FileMaker
## Requirements are:  no carriage returns in the comments field, zips are five digits or empty
## phone numbers are all digits or empty.  These need to be enforced at form submit.
## Will do a manual back-correct of the 2011 registrations so they conform

  def self.boolean_to_yesno(which)
    if which
      TrueClass.send(:define_method, "to_s"){"Yes"}
      FalseClass.send(:define_method, "to_s"){"No"}
    else
      TrueClass.send(:define_method, "to_s"){"true"}
      FalseClass.send(:define_method, "to_s"){"false"}
    end
  end

  def clean_comments
    comments.strip.gsub(/\s+/, " ")
  end

  def clean_home_phone; home_phone ? home_phone.gsub(/[^\d]/, "") : ""; end
  def clean_cell_phone; cell_phone ? cell_phone.gsub(/[^\d]/, "") : ""; end
  def clean_work_phone; work_phone ? work_phone.gsub(/[^\d]/, "") : ""; end
  def clean_emergency_contact_phone; emergency_contact_phone ? emergency_contact_phone.gsub(/[^\d]/, "") : ""; end

  def participant_type
    return "Non-participant" unless participant
    return "Vocal" if instrument_name =~ /Voice/
    return "Instrumental"
  end

  #  Per SteveK request:  
  #     "Faculty" -- iff the faculty bit is set in the user record
  #     "Staff"   -- iff the staff bit is set in the user record and participant is false
  #     "Participant" -- iff not staff and participant is true
  #     "Other" -- otherwise
  #   
  def contact_type
    return "Faculty" if user.faculty
    return "Staff" if user.staff && !participant
    return "Participant" if participant
    return "Other"
  end
        
  def secondary_instrument_names
    instruments.map{|i|i.display_name}.join("~")
  end

  #  Save for later -- if we allow edit on the website, these might become real
  def arrival_date; return ""; end
  def arrival_time; return ""; end
  def departure_date; return ""; end
  def departure_time; return ""; end

  def created_on; created_at.strftime("%Y-%m-%d"); end
  def updated_on; updated_at.strftime("%Y-%m-%d"); end

  def publishindirectory
    !donotpublish
  end

  def no_single_room
    !single_room
  end

  def self.fields
   [:contact_id, :first_name, :last_name,
    :street1, :street2, :city, :state,  :zip, :country,
    :clean_home_phone, :clean_work_phone, :clean_cell_phone, 
    :email, 
    :emergency_contact_name, :clean_emergency_contact_phone, 
    :gender, :occupation, :participant_type, 
    :firsttime, :instrument_name,  :secondary_instrument_names,
    :mailinglist, :publishindirectory, :dorm, 
    :no_single_room,  :share_housing_with, :meals, :vegetarian, 
    :aircond, :handicapped_access, :fan, :sunday, :airport_pickup,
    :arrival_date, :arrival_time, :departure_date, :departure_time,
    :wine_glasses,
    :tshirts, :tshirtm, :tshirtl, :tshirtxl, :tshirtxxl, :tshirtxxxl,
    :donation, :clean_comments, 
    :created_on_date, :updated_on_date,
    :contact_type
   ]
  end

  def created_on_date
    created_at.strftime("%m/%d/%Y")
  end

  def updated_on_date
    updated_at.strftime("%m/%d/%Y")
  end

  def self.default_filename
    dir = "/home1/musical9/Dropbox/MMR/FileMakerRegistration/OnlineRegistrationUploads"
    type = "registrations"
    timestring = Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    Time.now.strftime("#{dir}/#{type}-#{timestring}.txt")
  end

  def self.dump_records(filename = nil)
    boolean_to_yesno(true)
    filename = default_filename unless filename
    records = []
    downloads = Download.find_all_by_download_type("registrations").sort{|d1, d2| d2.downloaded_at <=> d1.downloaded_at}
    download_cutoff = downloads.empty? ? Date.new(2000,1,1).to_time : downloads.first.downloaded_at

    File.open(filename, 'w') do |file|
      file.puts fields.map{|field|field.to_s}.map{|m| m.gsub(/clean_/,"")}.join("\t")
      records =  Registration.find_all_by_year(Year.this_year).select{|r| r.updated_at > download_cutoff}
      records.each{|r| r.export(file)}
    end

    boolean_to_yesno(false)
    Download.create(:download_type => "registrations", :downloaded_at => Time.now)
    records.size
  end

  def export(file)
    downloaded_at = Time.now
    save!
    file.puts Registration.fields.map{|field| self.send(field)}.join("\t")
  end

end

