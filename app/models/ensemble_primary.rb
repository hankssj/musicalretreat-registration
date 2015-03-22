class EnsemblePrimary < ActiveRecord::Base
  belongs_to :registration
  has_many :mmr_chambers
  has_many :prearranged_chambers
  has_many :ensemble_primary_elective_ranks
  has_many :evaluations

  validates :registration, presence: true
  validates :large_ensemble_choice,
      presence: { message: "Morning large ensemble choice is required", on: :create }

  validates :large_ensemble_part,
     presence: { message: "You must provide additional informations about your morning large ensemble choice", on: :create },
     if: lambda{|e| e.large_ensemble_choice != 0 && (e.instrument.string? || e.instrument.flute? || e.instrument.clarinet? || e.instrument.saxophone_nonspecific?) }

  validates :chamber_ensemble_choice, presence: { message: "You must specify yours chamber ensemble preferences" }, 
    if: lambda{|e| e.step === :afternoon_ensembles_and_electives }

  validates_associated :mmr_chambers, message: 'Arranged Chamber Group is invalid'
  validates_associated :prearranged_chambers, message: 'Prearranged Chamber is invalid'
      
  accepts_nested_attributes_for :mmr_chambers
  accepts_nested_attributes_for :prearranged_chambers
  accepts_nested_attributes_for :evaluations

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

  def text_for_morning_enemble_choice
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
    elsif instrument.saxophone_nonspecfic? 
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
end
