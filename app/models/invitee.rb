# == Schema Information
# Schema version: 20111124000001
#
# Table name: invitees
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#  sent       :boolean(1)
#

class Invitee < ActiveRecord::Base
end
