class MmrChamber < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  validates :instrument, presence: {message: 'You have to specify instrument'}

  def self.ensemble_options
    [
      ['No assigned groups', 0],
      ['One assigned group', 1],
      ['Two assigned groups', 2]
    ]
  end
end
