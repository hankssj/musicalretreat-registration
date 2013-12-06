# == Schema Information
# Schema version: 20111124000001
#
# Table name: instruments
#
#  id           :integer(4)      not null, primary key
#  display_name :string(255)     not null
#  closed       :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

class Instrument < ActiveRecord::Base

	def self.menu_selection
		a = []
		self.find(:all, :order => :display_name).each do |inst|
			if !inst.closed 
				a << [inst.display_name, inst.id] 
			end
		end
		a
	end
end
