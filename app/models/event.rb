# == Schema Information
# Schema version: 20111124000001
#
# Table name: events
#
#  id         :integer(4)      not null, primary key
#  note       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
	
	def self.log(what)
		Event.new(:note => what).save
	end
	
end
