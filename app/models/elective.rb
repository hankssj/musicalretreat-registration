class Elective < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_many :ensemble_primary_elective_ranks
  has_many :ensemble_primaries, through: :ensemble_primary_elective_ranks
  has_many :registrations, through: :ensemble_primaries

  def instruments_for_selection
    Instrument.menu_selection_for_elective(self)
  end
end
