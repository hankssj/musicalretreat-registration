class EnsembleStepsController < ApplicationController
  include Wicked::Wizard

  steps :afternoon_ensembles_and_electives, :primary_chamber, :chamber_elective, :elective_evaluation, :evaluation_summary
  def show
    @ensemble_primary = EnsemblePrimary.find(session[:ensemble_primary_id])
    case step
    when :primary_chamber
      skip_step if @ensemble_primary.no_chamber_ensembles?
      @instrument_menu_selection = Instrument.menu_selection
      num_mmr, num_prearranged = EnsemblePrimary.parse_chamber_music_choice(@ensemble_primary.chamber_ensemble_choice)
      num_mmr.times.each{|i| @ensemble_primary.mmr_chambers.build }
      num_prearranged.times.each{|i| @ensemble_primary.prearranged_chambers.build(instrument: @ensemble_primary.registration.instrument) }
      flash[:ensemble_primary_id] = @ensemble_primary.id
    when :chamber_elective
      @electives = Elective.all
    when :elective_evaluation
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
    when :primary_chamber, :afternoon_ensembles_and_electives, :elective_evaluation
      @ensemble_primary.update_attributes(post_params)
      @instrument_menu_selection = Instrument.menu_selection
    when :chamber_elective
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
    end

    # NOTE -- this gets rid of all evaluations then creates new empty ones.
    # Not appropriate for edit situations!
    @ensemble_primary.evaluations.each{|e|e.destroy}
    Rails.logger.warn("Needed: #{@ensemble_primary.need_eval_for.length}")
    @ensemble_primary.need_eval_for.each do |iid|
      Evaluation.create!(:ensemble_primary_id => @ensemble_primary.id,
                         :instrument_id => iid,
                         :type => Instrument.find(iid).instrumental? ? "InstrumentalEvaluation" : "VocalEvaluation")
    end

    @ensemble_primary.step = step
    render_wizard @ensemble_primary
  end

  private

  def post_params
    params.require(:ensemble_primary).permit(
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
      ]
    )
  end
end
