# == Schema Information
# Schema version: 20111124000001
#
# Table name: cancellations
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
#  registration_id         :integer(4)
#  country                 :string(255)     default("US")
#

#  Implicitly this assumes that this class has the same fields that Registration does.
#  Bad assumption!  So explicitly we will just punt on those
class Cancellation < ActiveRecord::Base
  #def method_missing(x,y)
  #  x.to_s
  #end
end
