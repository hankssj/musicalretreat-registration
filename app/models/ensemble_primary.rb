class EnsemblePrimary < ActiveRecord::Base
  after_validation :skip_invalid_messages
  belongs_to :registration
  has_many :mmr_chambers, dependent: :destroy
  has_many :prearranged_chambers, dependent: :destroy
  has_many :ensemble_primary_elective_ranks, dependent: :destroy, inverse_of: :ensemble_primary
  has_many :electives, through: :ensemble_primary_elective_ranks
  has_many :evaluations, dependent: :destroy
  has_many :instruments, through: :evaluations

  scope :completed, lambda { where(complete: true) }
  validates :registration, presence: true
  validates :large_ensemble_choice,
      presence: { message: "Morning large ensemble choice is required", on: :create }

  validates :large_ensemble_part,
     presence: { message: "Please provide a seating preference for your large ensemble", on: :create },
     if: lambda{|e| e.large_ensemble_choice > 0 && 
                    (e.instrument.violin?  || e.instrument.flute? || e.instrument.clarinet? || e.instrument.saxophone_nonspecific?)}

  validates :chamber_ensemble_choice, presence: {message: "You must specify your chamber ensemble preferences"}, 
       if: lambda{|e| e.step === :afternoon_ensembles_and_electives }

  validates :ensemble_primary_elective_ranks,
    length: { within: 1..5, message: 'You have to choose at least one elective' },
    if: lambda{|e| e.step === :chamber_elective }
      
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

  def has_afternoon_ensembles
    chamber_ensemble_choice && chamber_ensemble_choice > 0
  end

  #######################################################################################
  # Chamber music choices. AKA afternoon groups.  Driven by chamber_music_choice variable

  def text_for_chamber_ensemble_choice
    ["No afternoon chamber groups",
     "One assigned chamber group",
     "One prearranged chamber group, one coached hour",
     "Two assigned chamber groups",
     "One assigned and one prearranged chamber group",
     "One prearranged chamber group, two coached hours",
     "Two prearranged chamber groups"][chamber_ensemble_choice]
  end

  def no_chamber_ensembles?
    chamber_ensemble_choice == 0
  end

  def parse_chamber_ensemble_choice
    num_mmr = num_prearranged = 0
    case chamber_ensemble_choice
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

  def rebuild_chamber_ensembles
    prearranged_chambers.each(&:destroy!)
    mmr_chambers.each(&:destroy!)
    prearranged_chambers.reload
    mmr_chambers.reload
    num_assigned, num_prearranged = parse_chamber_ensemble_choice
    num_assigned.times.each{|i| mmr_chambers.build}
    num_prearranged.times.each{|i| prearranged_chambers.build(instrument: primary_instrument)}
  end

  ######################################################
  # Evaluations

  def need_eval_for
    instrument_ids = (mmr_chambers + prearranged_chambers + ensemble_primary_elective_ranks).map(&:instrument_id) + [default_instrument_id]

    #  Need to specifically add Flute, if "Flute Choir" is in the chosen electives, need 
    #  flute evaluation.  Note the disgusting dependency on both the instrument ID and the elective name.
    if electives.map(&:name).include?("Flute Choir")
      instrument_ids << 11
    end

    # If somebody says Piccolo and not Flute, we say Flute instead.  So there is only one eval.
    if instrument_ids.include?(10)
      instrument_ids << 11
    end
    instrument_ids.compact.uniq.reject{|x| x <= 0}.reject{|x| x == 10}
  end

  def build_evaluations
    need_eval_for.each{|iid| evaluations.build(:instrument_id => iid, :type => Instrument.find(iid).instrumental? ? "InstrumentalEvaluation" : "VocalEvaluation")}
  end

  def rebuild_evaluations
    evaluations.each(&:destroy!)
    evaluations.reload
    build_evaluations
  end

  #  Enums

  ###########################################################

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
 
  def skip_invalid_messages
    filtered_errors = self.errors.reject{ |err| [:prearranged_chambers, :mmr_chambers].include?(err.first) }

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
    Elective.where.not(id: ensemble_primary_elective_ranks.map(&:elective_id)).map{|elective|ensemble_primary_elective_ranks.build(elective: elective)}
  end

  def secondary_instruments
    instruments - [instrument]
  end

  def secondary_instruments_of_type(type)
    (instruments - [instrument]).select do |instrument|
      instrument.instrument_type == type
    end
  end

  def instrument_for_elective(elective)
    ensemble_primary_elective_ranks.where(elective: elective).last.instrument
  end
  
  ############ Helpers for report/display
  def display_name; registration.display_name; end
  def email; registration.email; end
  def phone_number; registration.phone_number; end
  def primary_instrument_name; primary_instrument.display_name; end

  def text_for(attribute)
    case attribute
    when :large_ensemble_choice
      large_ensemble_choice_text
    when :large_ensemble_part
      large_ensemble_part_text
    when :large_ensemble_alternative
      large_ensemble_alternative_text
    when :chamber_ensemble_choice
      text_for_chamber_ensemble_choice
    end
    
  end

  def large_ensemble_choice_text
    texts = ["", 
             "Either Symphonic Band or Festival Orchestra", 
             "Symphonic Band", 
             "Festival Orchestra", 
             "Festival Chorus", 
             "String Orchestra", 
             "Either Festival or String Orchestra"]
    return unless large_ensemble_choice
    return "No morning large ensemble" if large_ensemble_choice == -1
    texts[large_ensemble_choice]
  end

  def large_ensemble_part_text
    return unless large_ensemble_part
    return ["No preference", "Prefer first violin", "Prefer second violin"][large_ensemble_part] if primary_instrument.violin? 
    return ["No preference", "Prefer first flute", "Prefer second flute", "", "", "", "", "", "", "", "Prefer piccolo"][large_ensemble_part] if primary_instrument.flute?
    return ["No preference", "Prefer first clarinet", "Prefer second clarinet", "Prefer third clarinet"][large_ensemble_part] if primary_instrument.clarinet?
    return ["No preference", "Prefer soprano sax", "Prefer alto sax", "Prefer tenor sax", "Prefer baritone sax"][large_ensemble_part-101] if primary_instrument.saxophone_nonspecific?
  end

  def large_ensemble_alternative_text
    return unless want_sing_in_chorus || want_percussion_in_band
    s = ""
    s += "Would like to sing in the Festival Chorus.  " if want_sing_in_chorus
    s += "Would like to talk to a faculty member about playing percussion in Symphonic Band." if want_percussion_in_band
    s
  end
end
