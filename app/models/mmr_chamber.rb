class MmrChamber < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  validates :instrument, presence: {message: 'You have to specify a voice or instrument'}

  def self.ensemble_options
    [
      ['No MMR Arranged Chamber Ensembles      ', 0],
      ['One MMR Arranged Chamber Ensemble      ', 1],
      ['Two MMR Arranged Chamber Ensembles     ', 2]
    ]
  end
end
