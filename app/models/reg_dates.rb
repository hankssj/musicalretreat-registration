require 'date'
class RegDates

  def self.registration_opens
    Time.local(Year.this_year,1,1,1,0,0)
  end

  def self.registration_balance_due
    Date.new(Year.this_year.to_i, 6, 1)
  end 

  def self.balance_due
    self.registration_balance_due
  end

  def self.wait_list_notification
    Date.new(Year.this_year.to_i, 6, 15)
  end 

  def self.scholarship_application
    Date.new(Year.this_year.to_i, 5, 1)
  end

  def self.scholarship_notification
    Date.new(Year.this_year.to_i, 5, 17)
  end

  def self.cancel_no_penalty
    Date.new(Year.this_year.to_i, 5, 1)
  end

  def self.cancel_no_refund
    Date.new(Year.this_year.to_i, 6, 1)
  end
end
