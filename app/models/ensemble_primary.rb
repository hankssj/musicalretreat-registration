class EnsemblePrimary < ActiveRecord::Base
  after_validation :skip_is_invalid_messages
  belongs_to :registration
  has_many :mmr_chambers
  has_many :prearranged_chambers
  has_many :ensemble_primary_elective_ranks, inverse_of: :ensemble_primary
  has_many :electives, through: :ensemble_primary_elective_ranks
  has_many :evaluations

  validates :registration, presence: true
  validates :large_ensemble_choice,
      presence: { message: "Morning large ensemble choice is required", on: :create }

  validates :large_ensemble_part,
     presence: { message: "You must provide additional informations about your morning large ensemble choice", on: :create },
     if: lambda{|e| e.large_ensemble_choice != 0 && (e.instrument.string? || e.instrument.flute? || e.instrument.clarinet? || e.instrument.saxophone_nonspecific?) }

  validates :chamber_ensemble_choice, presence: { message: "You must specify yours chamber ensemble preferences" }, 
    if: lambda{|e| e.step === :afternoon_ensembles_and_electives }

  validates :ensemble_primary_elective_ranks, length: { within: 1..5, message: 'You have to choose from 1 to 5 electives' }, if: lambda{|e| e.step === :chamber_elective }
      
  accepts_nested_attributes_for :mmr_chambers
  accepts_nested_attributes_for :prearranged_chambers
  accepts_nested_attributes_for :evaluations
  accepts_nested_attributes_for :ensemble_primary_elective_ranks

  attr_accessor :step, :choosed_prearranged_ensembles, :choosed_assigned_ensembles
  delegate :instrument, to: :registration

  def elective_ranks
    ensemble_primary_elective_ranks
  end

  def default_instrument_id
    registration.instrument_id
  end

  def primary_instrument
    Instrument.find(default_instrument_id)
  end

  def no_chamber_ensembles?
    chamber_ensemble_choice == 0
  end

  def need_eval_for
    instrument_ids = (mmr_chambers + prearranged_chambers + ensemble_primary_elective_ranks).map(&:instrument_id) + [default_instrument_id]
    instrument_ids.compact.uniq.reject{|x| x <= 0}
  end

  def build_evaluations
    self.need_eval_for.each do |iid|
      self.evaluations.build(
        :instrument_id => iid,
        :type => Instrument.find(iid).instrumental? ? "InstrumentalEvaluation" : "VocalEvaluation")
    end
  end
  #  Enums

  # def self.enum_name(enum_name, value)
  #   names = {
  #     :large_ensemble_choice => [:none, :either_band_or_festival_orchestra, :band, :festival_orchestra, :chorus, :string_orchestra, :either_festival_or_string_orchestra], 
  #     :chamber_ensemble_choice => [:none, :one_assigned, :one_prearranged_one_session, :two_assigned, :one_assigned_one_prearranged, :one_prearranged_two_sessions, :two_prearranged]
  #   }
  #   names[enum_name][value]
  # end

  def text_for_chamber_music_choice
    ["No afternoon chamber groups",
     "One assigned chamber group",
     "One prearranged chamber group, one coached hour",
     "Two assigned chamber groups",
     "One assigned and one prearranged chamber group",
     "One prearranged chamber group, two coached hours",
     "Two prearranged chamber groups"][chamber_ensemble_choice]
  end

  def text_for_morning_ensemble_choice
    if large_ensemble_choice < 1 
      "You will not be assigned a large ensemble."
    else
      ["You do not want to be assigned a large ensemble",
       "Either Symphonic Band or Festival Orchesta",
       "Symphonic Band",
       "Festival Orchestra",
       "Festival Chorus",
       "String Orchestra",
       "Either Festival or String Orchestra"][large_ensemble_choice]
    end
  end

  def text_for_morning_ensemble_part
    return "" unless large_ensemble_part
    if instrument.string?
      ["No preference", "First #{instrument.display_name}", "Second #{instrument.display_name}"][large_ensemble_part]
    elsif instrument.flute?
      ["No Preference", "First Flute", "Second Flute", "","","","","","","", "Piccolo"][large_ensemble_part]
    elsif instrument.clarinet?
      ["No Preference", "First Clarinet", "Second Clarinet", "Third Clarinet"][large_ensemble_part]
    elsif instrument.saxophone_nonspecific? 
      ["Soprano Sax", "Alto Sax", "Tenor Sax", "Baritone Sax"][large_ensemble_part]
    else
      raise "Unexpected large ensemble part #{large_ensemble_part}"
    end
  end
    
  def self.parse_chamber_music_choice(cmc)
    num_mmr = num_prearranged = 0
    case cmc
    when 0
      num_mmr = 0; num_prearranged = 0
    when 1
      num_mmr = 1; num_prearranged = 0
    when 2
      num_mmr = 0; num_prearranged = 1
    when 3
      num_mmr = 2; num_prearranged = 0
    when 4
      num_mmr = 1; num_prearranged = 1
    when 5
      num_mmr = 0; num_prearranged = 1
    when 6
      num_mmr = 0; num_prearranged = 2
    end
    [num_mmr, num_prearranged]
  end

  def skip_is_invalid_messages
    filtered_errors = self.errors.reject{ |err| [:ensemble_primary_elective_ranks, :prearranged_chambers, :mmr_chambers].include?(err.first) }

    filtered_errors.collect{ |err|
      if err[0] =~ /(.+\.)?(.+)$/
        err[0] = $2.titleize
      end
      err
    }

    self.errors.clear
    filtered_errors.each { |err| self.errors.add(*err) }
  end

  def build_ensemble_primary_elective_ranks
    Elective.where.not(id: self.ensemble_primary_elective_ranks.map(&:elective_id)).map do |elective|
      self.ensemble_primary_elective_ranks.build(elective: elective)
    end
  end
end
