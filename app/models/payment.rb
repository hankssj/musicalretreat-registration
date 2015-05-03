# == Schema Information
# Schema version: 20111124000001
#
# Table name: payments
#
#  id              :integer(4)      not null, primary key
#  registration_id :integer(4)      not null
#  amount          :decimal(8, 2)   not null
#  check_number    :string(255)
#  note            :string(255)
#  date_received   :date
#  scholarship     :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#  confirmed       :string(255)     default("1")
#  online          :boolean(1)
#

class Payment < ActiveRecord::Base
  belongs_to :registration
  
  validates_presence_of :registration_id
  validates_presence_of :amount
  validates_presence_of :date_received
  validates_numericality_of :amount
  
  attr_accessor :send_confirm_email

  def validate
    unless amount
      errors.add_to_base("Amount cannot be empty")
    end
    
    if amount && amount < 0
      errors.add_to_base("Negative payment amount")
    end
  end

  def cancel
    cp = CancelledPayment.new
    cp.payment_id = id
    attributes.keys.each{|k| cp.send("#{k}=", send(k)) unless k == "id"}
    cp.save!
    destroy
  end

  def contact_id
    registration && registration.user && registration.user.contact_id
  end

  def year
    registration && registration.year
  end

  #######################################################################
  ## For dumping text file for export to FileMaker

  #  Adjust the way check number and payment_type are handled.
  #  Currently check_number is overloaded -- in the case of online registration, the field is "Online/CC"
  #  In the case of manual payment, it's a field in the payment record.
  #  Split out the two and surface both payment_type and a renamed check_no.
  #  

  def check_no
    check_number == "Online/CC" ? "" : check_number
  end

  def payment_type
    check_number == "Online/CC" ? :credit_card : :check
  end

  def clean_note
    note ? note.strip.gsub(/\s+/, " ") : ""
  end

  def received_on_date
    date_received.strftime("%m/%d/%Y")
  end

  def to_txt_row
    Payment.fields.map {|field| self.send(field)}.join("\t")
  end

  ######################
  
  class << self

    def fields
      [:contact_id, :amount, :payment_type, :check_no, :clean_note, :received_on_date, :online]
    end

    def boolean_to_yesno(which)
      if which
        TrueClass.send(:define_method, "to_s"){"Yes"}
        FalseClass.send(:define_method, "to_s"){"No"}
      else
        TrueClass.send(:define_method, "to_s"){"true"}
        FalseClass.send(:define_method, "to_s"){"false"}
      end
    end

    def header_row
      fields.map{|field|field.to_s}.map{|m|m.gsub(/clean_/,"")}.join("\t")
    end

    def records_to_send
      downloads = Download.where(download_type: 'payments').order(downloaded_at: :desc)
      download_cutoff = downloads.empty? ? Date.new(2000,1,1).to_time : downloads.first.downloaded_at
      self.all.select{|p| p.year == Year.this_year}.
        reject{|p| !p.registration || p.registration.test}.
        select{|r| r.updated_at > download_cutoff}.
        sort_by(&:contact_id)
    end

    def update_download_time
      Download.create(download_type: "payments", downloaded_at: Time.now)
    end

    def list
      boolean_to_yesno(true)
      output =  header_row + "\n" + records_to_send.map{|p| p.to_txt_row}.join("\n") + "\n"
      boolean_to_yesno(false)
      update_download_time
      output
    end
  end
end
