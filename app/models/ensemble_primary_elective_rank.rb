class EnsemblePrimaryElectiveRank < ActiveRecord::Base
  belongs_to :ensemble_primary, inverse_of: :ensemble_primary_elective_ranks
  belongs_to :elective
  belongs_to :instrument

  validates :instrument, presence: { message: 'You have to chose an instrument' }, unless: lambda{|e| e.elective.instruments.empty? }
  validates :ensemble_primary, presence: true
  validates :elective, presence: true

  scope :by_rank, lambda{ order(:rank) }
end
