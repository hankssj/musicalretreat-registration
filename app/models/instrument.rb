class Instrument < ActiveRecord::Base
  has_and_belongs_to_many :electives

  def self.menu_selection
    menu_helper(Instrument.all.reject{|i| i.closed})
  end

  # Include only the selections linked to the elective_id
  def self.menu_selection_for_elective(elective)
    menu_helper(elective.instruments)
  end

  def instrumental?
    instrument_type == "instrumental"
  end
  
  def vocal?
    instrument_type == "vocal"
  end

  private
  def self.menu_helper(list_of_instruments)
    list_of_instruments.sort{|i1, i2| i1.display_name <=> i2.display_name}.map{|i| [i.display_name, i.id]}
  end
end
