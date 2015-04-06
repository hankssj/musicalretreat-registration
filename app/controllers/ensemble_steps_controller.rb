
class EnsembleStepsController < ApplicationController
  include Wicked::Wizard
  include RegistrationGating

  before_action :authorize
  before_action :set_user_or_handle_unauthorized
  before_action :set_ensamble_primary

  steps :afternoon_ensembles_and_electives, :primary_chamber, :chamber_elective, :elective_evaluation, :evaluation_summary

  def show
    case step
    when :primary_chamber
      @ensemble_primary.rebuild_chamber_ensembles
      skip_step if @ensemble_primary.no_chamber_ensembles?
      @instrument_menu_selection = Instrument.menu_selection
      @num_assigned, @num_prearranged = @ensemble_primary.parse_chamber_music_choice
      session[:ensemble_primary_id] = @ensemble_primary.id
    when :chamber_elective
    when :elective_evaluation
      @ensemble_primary.rebuild_evaluations
    end
    render_wizard
  end

  def update
    case step
    when :primary_chamber, :afternoon_ensembles_and_electives
      @ensemble_primary.update_attributes(post_params)
      @instrument_menu_selection = Instrument.menu_selection
    when :chamber_elective
      @ensemble_primary.ensemble_primary_elective_ranks.each(&:destroy!)
      @ensemble_primary.ensemble_primary_elective_ranks.reload
      @ensemble_primary.update_attributes(post_params)
    when :elective_evaluation
      @ensemble_primary.update_attributes(post_params)
    when :evaluation_summary
      return redirect_to registration_index_path if @ensemble_primary.update_attributes(post_params)
    end
    @ensemble_primary.step = step
    render_wizard @ensemble_primary
  end

  private

  def post_params
    params.fetch(:ensemble_primary, {}).permit(
      :registration_id,
      :primary_instrument_id,
      :large_ensemble_choice,
      :chamber_ensemble_choice,
      :ack_no_morning_ensemble,
      :want_sing_in_chorus,
      :want_percussion_in_band,
      :comments,
      mmr_chambers_attributes: [
        :instrument_id,
        :jazz_ensamble,
        :string_novice,
        :notes
      ],
      prearranged_chambers_attributes: [
        :instrument_id,
        :i_am_contact,
        :contact_name,
        :contact_email,
        :participant_names,
        :bring_own_music,
        :music_composer_and_name,
        :notes
      ],
      ensemble_primary_elective_ranks_attributes: [
        :rank,
        :elective_id,
        :instrument_id
      ],
      evaluations_attributes: [
        :ensemble_primary_id,
        :instrument_id,
        :type,
        :chamber_ensemble_part,
        :transposition_0,
        :transposition_1,
        :transposition_2,
        :other_instrument_oboe,
        :other_instrument_english_horn,
        :other_instrument_oboe_other,
        :other_instrument_trombone,
        :other_instrument_bass_trombone,
        :other_instrument_bb_trumpet,
        :other_instrument_c_trumpet,
        :other_instrument_piccolo_trumpet,
        :other_instrument_saxophone_soprano,
        :other_instrument_saxophone_alto,
        :other_instrument_saxophone_tenor,
        :other_instrument_saxophone_baritone,
        :other_instrument_bb_clarinet,
        :other_instrument_a_clarinet,
        :other_instrument_eb_clarinet,
        :other_instrument_alto_clarinet,
        :other_instrument_bass_clarinet,
        :other_instrument_c_flute,
        :other_instrument_piccolo,
        :other_instrument_alto_flute,
        :other_instrument_bass_flute,
        :other_instrument_drum_set,
        :other_instrument_mallets,
        :other_instruments_you_tell_us,
        :percussion_snare,
        :percussion_timpani,
        :percussion_mallets,
        :percussion_small_instruments,
        :percussion_drum_set,
        :groups,
        :require_audition,
        :studying_privately,
        :studying_privately_how_long,
        :chamber_music_how_often,
        :practicing_how_much,
        :composers,
        :jazz_want_ensemble,
        :jazz_small_ensemble,
        :jazz_big_band,
        :vocal_low_high,
        :vocal_overall_ability,
        :vocal_how_learn,
        :vocal_most_difficult_piece,
        :vocal_music_theory,
        :vocal_music_theory_year,
        :vocal_voice_class,
        :vocal_voice_class_year,
        :vocal_voice_lessons,
        :vocal_voice_lessons_year,
        :vocal_small_ensemble_skills,
        :third_position,
        :fourth_position,
        :fifth_position,
        :sixth_position,
        :seventh_position,
        :thumb_position,
        :overall_rating_large_ensemble,
        :overall_rating_chamber,
        :overall_rating_sightreading,
      ]
    )
  end

  def set_user_or_handle_unauthorized
    if !session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :controller => :registration, :action => :index
    end

    @user = User.find(session[:user_id])

    if @user.nil?
      flash[:notice] = "Please log in first"
      redirect_to :controller => :registration, :action => :index
    elsif !@user.has_current_registration
      flash[:notice] = "You need to register first"
      redirect_to :controller => :registration, :action => :index
    end
  end

  def set_ensamble_primary
    @ensemble_primary = @user.most_recent_registration
      .ensemble_primaries.find(session[:ensemble_primary_id])
  end
end
