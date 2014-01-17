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
