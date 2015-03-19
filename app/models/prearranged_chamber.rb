class PrearrangedChamber < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  validates :instrument, presence: {message: 'You have to specify instrument'}
  validates :contact_name, presence: {message: 'Contact name can\'t be blank'}, unless: lambda { |c| c.i_am_contact }
  validates :contact_email, presence: {message: 'Contact email can\'t be blank'}, unless: lambda { |c| c.i_am_contact }
  validates :participant_names, presence: {message: 'You have to specify participant instruments and names'}, if: lambda { |c| c.i_am_contact }
  validates :music_composer_and_name, presence: {message: 'Music composer and name of piece can\'t be blank'}, if: lambda { |c| c.i_am_contact && c.bring_own_music }

  def self.ensemble_options
    [
      ['No prearranged groups', 0],
      ['One prearranged group, one choached hour', 1],
      ['One prearranged group, two coached hours', 2],
      ['Two prearranged groups', 3]
    ]
  end
end
