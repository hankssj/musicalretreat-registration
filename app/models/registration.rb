class Registration < ActiveRecord::Base

  belongs_to :user
  has_many :payments
  belongs_to :instrument
  has_many :ensemble_primaries, dependent: :destroy

  # Validation:  first and last name not empty; first line of street address, city, state, zip not empty
  # Phone numbers validate
  # Primary instrument must be selected if particpant

  validates_each :first_name, :last_name, :street1, :city, :state, :zip do |record, attr, value|
    record.errors.add(attr, "#{Registration.human_attribute_name(attr)} is required") if value.blank?
  end
  
  validates_each :instrument_id do |record, attr, value|
    unless value || !record.participant
      record.errors.add(attr, "You must select primary instrument or voice")
    end
  end
  validates_each :home_phone, :work_phone, :cell_phone do |record, attr, value|
    unless value.empty? || value.gsub(/[^\d]/,"").length == 10
      record.errors.add(attr, 'Please use 10-digit phone numbers, put international numbers in comments')
    end
  end

  # Ensemble primaries can be left in an incomplete state if user exits the work flow
  # Delete all the incomplete ones and 
  def ensemble_primaries_incomplete?
    ensemble_primaries.each{|e| e.destroy unless e.complete}
    ensemble_primaries.reload
    ensemble_primaries.empty?
  end

  def ensemble_primaries_complete?
    !ensemble_primaries_incomplete?
  end

  def instrument_name
    instrument_id ? Instrument.find(instrument_id).display_name : "None"
  end
  
  def display_name
    first_name + " " + last_name
  end

  def phone
    home_phone || cell_phone || work_phone
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
  
  #  Some fields need reasonable defaults (double occupancy, all meals, participant).  And we can't always 
  #  rely on old registrations to have good default values because when we add field we have null values, and 
  #  those cause mischeif!

  def self.populate(user)
    reg = user.most_recent_registration
    new_reg = reg ? reg.dup : Registration.new
    new_reg.year = Year.this_year
    new_reg.user_id = user.id
    new_reg.comments = ""

    # defaults
    new_reg.firsttime = reg.nil?
    new_reg.participant ||= true
    new_reg.dorm_selection ||= "d"
    new_reg.meals_selection ||= "f"
    new_reg.aircond ||= false
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

    # 2013
    # if staff? 
    #   tstotal = tstotal - 1
    #   tstotal = 0 if tstotal < 0
    # elsif board? #  Board gets flat rate, with dorm rooms, sunday arrival and one T-shirt included
    #   c.set_quantity("Board Member Flat Rate", 1)
    #   tstotal = tstotal - 1
    #   tstotal = 0 if tstotal < 0
    # else
    #   c.set_quantity("Registration", 1)
    #   c.set_quantity("Tuition", participant ? 1 : 0)
    #   c.set_quantity("Dorm", dorm ? 1 : 0)
    #   c.set_quantity("Meals", meals ? 1 : 0)
    #   c.set_quantity("No Breakfast", meals && meals_lunch_and_dinner_only ? 1 : 0)
    # end
    #c.set_quantity("Commemorative Wine Glass", wine_glasses)

    if staff?
      tstotal = tstotal <= 1 ? 0 : tstotal - 1
    elsif board?
      tstotal = tstotal <= 1 ? 0 : tstotal - 1
      c.set_quantity("Dorm", (dorm_selection == 'd' || dorm_selection == 's') ? 1 : 0)
      c.set_quantity("Single Room", dorm_selection == 's' ? 1 : 0)
      c.set_quantity("Meals", (meals_selection == 'f' || meals_selection == 'l') ? 1 : 0)
      c.set_quantity("No Breakfast", meals_selection == 'l' ? 1 : 0)
    else
      c.set_quantity("Registration", 1)
      c.set_quantity("Tuition", participant ? 1 : 0)
      c.set_quantity("Dorm", (dorm_selection == 'd' || dorm_selection == 's') ? 1 : 0)
      c.set_quantity("Single Room", (dorm_selection == 's') ? 1 : 0)
      c.set_quantity("Meals", (meals_selection == 'f' || meals_selection == 'l') ? 1 : 0)
      c.set_quantity("No Breakfast", meals_selection == 'l' ? 1 : 0)
      c.set_quantity("Sunday Arrival", (sunday && dorm) ? 1 : 0)
    end

    #  Add-ons for everybody
    c.set_quantity("Tshirts", tstotal)
    c.set_quantity("Commemorative Wine Glass", wine_glasses)
    donation ? c.install_charge("Donation", donation) : c.set_quantity("Donation", 0)

    c
  end	
  
  ###########################################
  ##  Payments, deposits and the like
  
  def total_payments
    total = 0
    payments.each{|payment| total += payment.amount}
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
##  after initial registration, or when returning to pay either deposit or balance. 
##  Balance is charges net of payment (displayed on cart)
##  Total is charges without deducting payment (passed through to cc controller)

  def deposit; [Charge.charge_for("Deposit").to_f, balance].min; end
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

  def clean_comments; comments ? comments.strip.gsub(/\s+/, " ") : ""; end
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

  # 12/2013 I believe we have no more secondary instruments.  Consider dropping this
  # 2/2014 -- You were right we don't.  But getting rid of it altogether alters the output file format
  def secondary_instrument_names
    #instruments.map{|i|i.display_name}.join("~")
    ""
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

  #  2014  -- Dorm and meals attributes
  #  Previously there were fields dorm, meals, and meals_lunch_and_dinner_only
  #  As of 2014 there are two radio button controls and two new attributes
  #     dorm:  attribute is dorm_selection and possible values are "d" "s" and "n" (double, single, none)
  #     meals:  attribute is meals_selection and possible values are "f" "l" and "n" (full, lunch/dinner only, none)
  #
  #  The attributes dorm, meals, and meals_lunch_and_dinner_only are no longer set.
  #  Filemaker must have the following fields:
  #    dorm, no_single_room, meals, and other_2
  #  the last one will be used for the lunch and dinner option, which will be a deduction from the meals charge.
  #  
  #  So we define those fields here:

  def dorm 
    dorm_selection == 'd' || dorm_selection == 's'
  end
  
  def no_single_room
    dorm_selection == 'd'
  end

  def meals
    meals_selection == 'f' || meals_selection == 'l'
  end

  def other_2
    meals_selection == 'l'
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
    :contact_type,
    :other_2
   ]
  end

  def created_on_date
    created_at.strftime("%m/%d/%Y")
  end

  def updated_on_date
    updated_at.strftime("%m/%d/%Y")
  end

  # Download file for FileMaker input.  Called from admin/registrations_controller
  def self.list
    first_download = Download.where(download_type: 'registrations').order(downloaded_at: :desc).first
    download_cutoff = first_download ? first_download.downloaded_at : Date.new(2000,1,1).to_time
    output = ""
    output += fields.map{|field|field.to_s}.map{|m|m.gsub(/clean_/,"")}.join("\t") + "\n"
    records =  Registration.where(["year = ? and updated_at > ?", Year.this_year, download_cutoff]).reject{|r|r.test}
    begin
      Registration.boolean_to_yesno(true)
      output += records.map {|r| r.to_txt_row}.join("\n")
    ensure
      Registration.boolean_to_yesno(false)
    end
    Download.create(download_type: "registrations", downloaded_at: Time.now)
    output
  end

  def to_txt_row
    Registration.fields.map { |field| self.send(field) }.join("\t")
  end
end

