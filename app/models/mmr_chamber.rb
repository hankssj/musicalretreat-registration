class MmrChamber < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  validates :instrument, presence: {message: 'You have to specify a voice or instrument'}

  def self.ensemble_options
    [
      ['No MMR arranged chamber ensembles      ', 0],
      ['One MMR arranged chamber ensemble      ', 1],
      ['Two MMR arranged chamber ensembles     ', 2]
    ]
  end
end
