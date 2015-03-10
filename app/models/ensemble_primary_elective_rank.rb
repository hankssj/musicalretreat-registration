class EnsemblePrimaryElectiveRank < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :elective
  belongs_to :instrument
end
