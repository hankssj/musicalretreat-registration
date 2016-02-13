class PrearrangedChamber < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  validates :instrument, presence: {message: 'You have to provide a voice or instrument'}
  validates :contact_name, presence: {message: 'Contact name can\'t be blank'}, unless: lambda { |c| c.i_am_contact }
  #validates :contact_email, presence: {message: 'Contact email can\'t be blank'}, unless: lambda { |c| c.i_am_contact }
  validates :participant_names, presence: {message: 'You have to specify participant instruments and names'}, if: lambda { |c| c.i_am_contact }
  validates :music_composer_and_name, presence: {message: 'Music composer and name of piece can\'t be blank'}, if: lambda { |c| c.i_am_contact && c.bring_own_music }

  def active?
    ensemble_primary && ensemble_primary.registration && ensemble_primary.complete
  end

  def self.ensemble_options
    [
      ['No Prearranged Groups                   ', 0],
      ['One Prearranged Group, One Coached Hour',  1],
      #['One Prearranged Group, Two Coached Hours', 2],
      ['Two Prearranged Groups                  ', 3]
    ]
  end

  def cleanse(str)
    str.gsub("\t", " ").gsub("\n", "").gsub("\r", "")
  end

  ###################################################

  def self.file_header_line
    "first_name\tlast_name\temail\tphone_number\tinstrument_or_voice\t" +
      "i_am_contact\tcontact_name\tcontact_email\tparticipant_names\tbring_own_music\t" +
      "music_composer_and_name\tcomments"
  end

  def file_line
        [ensemble_primary.registration.first_name, 
         ensemble_primary.registration.last_name, 
         ensemble_primary.email, 
         ensemble_primary.phone_number, instrument.display_name,
         i_am_contact, contact_name, contact_email, cleanse(participant_names),
         bring_own_music, cleanse(music_composer_and_name), 
         cleanse(notes)].join("\t")
  end

  def self.dump_file(filename=nil)
    filename ||= "/home/deploy/Dropbox/SelfEvalDownloads/#{Year.this_year}/prearranged_afternoon_ensemble.tsv"
    File.open(filename, "w") do |outfile|
      outfile.puts file_header_line
      all.select(&:active?).reject{|e|e.ensemble_primary.registration.test}.each{|e| outfile.puts(e.file_line)}
    end
  end

end
