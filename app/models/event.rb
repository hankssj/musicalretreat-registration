class Event < ActiveRecord::Base
  def self.log(what)
    Event.new(:note => what).save
  end
  
  def self.notes
    Event.all.sort{|e1, e2| e1.created_at <=> e2.created_at}.map{|e|e.note}
  end
end
