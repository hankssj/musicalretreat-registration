class EnsemblePrimary < ActiveRecord::Base
  belongs_to :registration
  has_many :mmr_chambers
  has_many :prearranged_chambers
  has_and_belongs_to_many :electives
  has_many :ensemble_primary_elective_ranks

  accepts_nested_attributes_for :mmr_chambers
  accepts_nested_attributes_for :prearranged_chambers

  def default_instrument_id
    registration.instrument_id
  end
end
