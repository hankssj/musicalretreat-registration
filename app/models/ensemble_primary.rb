class EnsemblePrimary < ActiveRecord::Base
  belongs_to :registration
  has_many :mmr_chambers
  has_many :prearranged_chambers
  has_many :ensemble_primary_elective_ranks
  has_many :evaluations
  has_and_belongs_to_many :electives

  accepts_nested_attributes_for :mmr_chambers
  accepts_nested_attributes_for :prearranged_chambers
  accepts_nested_attributes_for :evaluations

  def default_instrument_id
    registration.instrument_id
  end

  def primary_instument
    Instrument.find(default_instrument_id)
  end

  def need_eval_for
    instrument_ids = 
      prearranged_chambers.map{|x| x.instrument_id} + ensemble_primary_elective_ranks.map{|x| x.instrument_id} + [default_instrument_id]
    instrument_ids.compact.uniq.reject{|x| x <= 0}
  end

  #  Enums
  enum :large_ensemble_choice => [:none, :either_band_or_orchestra, :band, :orchestra, :chorus]
  enum :chamber_ensemble_choice => [:none, :one_assigned, :one_prearranged_one_session, :two_assigned, :one_assigned_one_prearranged, :one_prearranged_two_sessions, :two_prearranged]
end
