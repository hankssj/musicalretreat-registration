class EnsembleStepsController < ApplicationController
  include Wicked::Wizard

  steps :afternoon_ensembles_and_electives, :primary_chamber, :chamber_elective, :elective_evaluation, :evaluation_summary
  def show
    @ensemble_primary = EnsemblePrimary.find(session[:ensemble_primary_id])
    case step
    when :primary_chamber
      @ensemble_primary.prearranged_chambers.each do |pc|
        pc.destroy
      end
      @ensemble_primary.mmr_chambers.each do |ec|
        ec.destroy
      end
      @ensemble_primary.mmr_chambers.reload
      @ensemble_primary.prearranged_chambers.reload
      skip_step if @ensemble_primary.no_chamber_ensembles?
      @instrument_menu_selection = Instrument.menu_selection
      @num_assigned, @num_prearranged = EnsemblePrimary.parse_chamber_music_choice(@ensemble_primary.chamber_ensemble_choice)
      @num_assigned.times.each{|i| @ensemble_primary.mmr_chambers.build }
      @num_prearranged.times.each{|i| @ensemble_primary.prearranged_chambers.build(instrument: @ensemble_primary.registration.instrument) }
      flash[:ensemble_primary_id] = @ensemble_primary.id
    when :chamber_elective
    when :elective_evaluation
      @ensemble_primary.build_evaluations
    end

    render_wizard
  end

  def chamber_elective
    @ensemble_primary = EnsemblePrimary.find(session[:ensamble_primary_id])

    if params[:ensemble_primary][:mmr_chambers_attributes]
      params[:ensemble_primary][:mmr_chambers_attributes].values.each do |h|
        raise "upate error" unless MmrChamber.find(h["id"].to_i).update_attributes(h)
      end
    end

    if params[:ensemble_primary][:prearranged_chambers_attributes]
      params[:ensemble_primary][:prearranged_chambers_attributes].values.each do |h|
        raise "upate error" unless PrearrangedChamber.find(h["id"].to_i).update_attributes(h)
      end
    end

    raise "Problem with save" unless @ensemble_primary.update_attributes(post_params)

    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id])
    @electives = Elective.all
    flash[:ensemble_primary_id] = @ensemble_primary.id
  end

  def elective_evaluation
    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id])
    id_keys = params.keys.select{|k| k =~ /^id_\d+$/}.reject{|k| params[k].empty?}
    @ensemble_primary.ensemble_primary_elective_ranks.each{|x|x.destroy}
    id_keys.each do |id_key|
      elective_id = id_key.split("_")[1].to_i
      if (elective_id == 0)
        raise "No zero ID for me"
      end
      rank = params[id_key].to_i
      instrument_id = params["instrument_id_#{elective_id}"].to_i
      EnsemblePrimaryElectiveRank.create(:ensemble_primary_id => @ensemble_primary.id,
                                         :elective_id => elective_id,
                                         :instrument_id => instrument_id,
                                         :rank => rank)
    end
    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id])

    # NOTE -- this gets rid of all evaluations then creates new empty ones.
    # Not appropriate for edit situations!
    @ensemble_primary.evaluations.each{|e|e.destroy}
    Rails.logger.warn("Needed: #{@ensemble_primary.need_eval_for.length}")
    @ensemble_primary.need_eval_for.each do |iid|
      Evaluation.create!(:ensemble_primary_id => @ensemble_primary.id,
                         :instrument_id => iid,
                         :type => Instrument.find(iid).instrumental? ? "InstrumentalEvaluation" : "VocalEvaluation")
    end

    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id])
    flash[:ensemble_primary_id] = @ensemble_primary.id
  end

  def evaluation_summary
    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id])
    @params = params
    if params[:ensemble_primary][:evaluations_attributes]
      params[:ensemble_primary][:evaluations_attributes].values.each do |h|
        raise "upate error" unless Evaluation.find(h["id"].to_i).update_attributes(h)
      end
    end
    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id])
    flash[:ensemble_primary_id] = @ensemble_primary.id
  end

  def update
    @ensemble_primary = EnsemblePrimary.find(session[:ensemble_primary_id])
    case step
    when :primary_chamber, :afternoon_ensembles_and_electives
      @ensemble_primary.update_attributes(post_params)
      @instrument_menu_selection = Instrument.menu_selection
    when :chamber_elective
      @ensemble_primary.ensemble_primary_elective_ranks.each do |elective_rank|
        elective_rank.destroy
      end
      @ensemble_primary.ensemble_primary_elective_ranks.reload
      @ensemble_primary.update_attributes(post_params)
    when :elective_evaluation
      @ensemble_primary.evaluations.each{ |e| e.destroy }
      @ensemble_primary.evaluations.reload
      @ensemble_primary.update_attributes(post_params)
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
        :overall_rating_sightreading
      ]
    )
  end
end
