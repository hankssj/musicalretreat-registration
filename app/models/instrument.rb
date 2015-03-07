class Instrument < ActiveRecord::Base
  has_and_belongs_to_many :electives

  def self.menu_selection(elective_id=nil)
    if elective_id
      raise "incomplete"
    else
      Intrument.all.sort{|i1, i2| i1.display_name <=> i2.display_name}.reject{|i| i.closed }.map{|i| [i.display_name, i.id]}
    end
  end

end
