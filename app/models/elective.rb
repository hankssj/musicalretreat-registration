class Elective < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_many :ensembles_primaries, through: :ensemble_primary_elective_ranks

  def instruments_for_selection
    Instrument.menu_selection_for_elective(self)
  end
end
