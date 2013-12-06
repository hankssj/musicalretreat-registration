# == Schema Information
# Schema version: 20111124000001
#
# Table name: cancelled_payments
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
#  payment_id      :integer(4)      not null
#  online          :boolean(1)
#  confirmed       :string(255)
#

class CancelledPayment < ActiveRecord::Base
end
