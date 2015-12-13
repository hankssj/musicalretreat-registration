class MmrChamber < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  def active?
    ensemble_primary && ensemble_primary.registration && ensemble_primary.complete
  end

  validates :instrument, presence: {message: 'You have to specify a voice or instrument'}

  def self.ensemble_options
    [
      ['No MMR Arranged Chamber Ensembles      ', 0],
      ['One MMR Arranged Chamber Ensemble      ', 1],
      ['Two MMR Arranged Chamber Ensembles     ', 2]
    ]
  end

  ########################################

  def self.file_header_line
    "first_name\tlast_name\temail\tphone_number\tinstrument_or_voice\t" +
      "string_novice\tjazz_ensemble\tcomments"
  end

  def file_line
        [ensemble_primary.registration.first_name, 
         ensemble_primary.registration.last_name, 
         ensemble_primary.email, 
         ensemble_primary.phone_number, instrument.display_name,
         string_novice, 
         jazz_ensemble,
         notes.gsub("\t", " ").gsub("\n", "").gsub("\r", "")].join("\t")
  end

  def self.dump_file(filename=nil)
    filename ||= "/home/deploy/Dropbox/SelfEvalDownloads/#{Year.this_year}/assigned_afternoon_ensemble.tsv"
    File.open(filename, "w") do |outfile|
      outfile.puts file_header_line
      all.select(&:active?).reject{|e|e.ensemble_primary.registration.test}.each{|e| outfile.puts(e.file_line)}
    end
  end

end
