class EnsemblesController < ApplicationController

  include RegistrationGating

  before_filter :authorize, :only => [:primary]

  def primary
    user = User.find(session[:user_id])
    if user && user.has_current_registration
      @registration = user.most_recent_registration
      unless @registration.instrument_id
        flash[:notice] = "You registered as a non-particpant -- no ensemble choice for you"
        redirect_to :controller => :registration, :action => :index
      end
    else
      flash[:notice] = "You do not have a current registration"
      Event.log("#{user.email} tried to choose ensembles but no registration")
      redirect_to :controller => :registration, :action => "index"
    end
    @ensemble_primary = EnsemblePrimary.new(:registration_id => @registration.id)
  end
  
  def chamber
    @ensemble_primary = EnsemblePrimary.new(post_params)
    unless @ensemble_primary.save
      Rails.logger.error("Save on primary failed -- #{@ensemble_primary.error.full_messages}")
      raise e
    end
    num_mmr = num_prearranged = 0
    case @ensemble_primary.chamber_ensemble_choice
      when 0
      num_mmr = 0; num_prearranged = 0
      when 1
      num_mmr = 1; num_prearranged = 0
      when 2
      num_mmr = 0; num_prearranged = 1
      when 3
      Rails.logger.error("Choice 3")
      num_mmr = 2; num_prearranged = 0
      when 4
      num_mmr = 1; num_prearranged = 1
      when 5
      num_mmr = 0; num_prearranged = 1
      when 6
      num_mmr = 0; num_prearranged = 2
    end
    num_mmr.times.each{|i| Rails.logger.error("Create in MMR"); MmrChamber.create!(:ensemble_primary_id => @ensemble_primary.id)}
    num_prearranged.times.each{|i| Rails.logger.error("Create in prearranged");PrearrangedChamber.create!(:ensemble_primary_id => @ensemble_primary.id)}
  end

  def create_chamber
    @ensemble_primary = EnsemblePrimary.find(params[:ensemble_primary][:id])
    
    params[:ensemble_primary][:mmr_chambers_attributes].values.each{|h| raise "upate error" unless MmrChamber.find(h["id"].to_i).update_attributes(h)}
    params[:ensemble_primary][:prearranged_chambers_attributes].values.each{|h| raise "upate error" unless PrearrangedChamber.find(h["id"].to_i).update_attributes(h)}

    unless @ensemble_primary.update_attributes(post_params)
      raise "Problem with save"
    end
    #redirect_to :action => :electives
    @params = params
  end
      
  def electives
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
                                             :mmr_chambers,
                                             :prearranged_chambers
                                             )

  end
end

