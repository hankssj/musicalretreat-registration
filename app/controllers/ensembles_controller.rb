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
    Rails.logger.error("Ensemble choice #{@ensemble_primary.chamber_ensemble_choice}")
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
    Rails.logger.error("#{num_mmr} #{num_prearranged}")
    @ensemble_primary.mmr_chambers = [1..num_mmr].map{|i| MmrChamber.create!}
    @ensemble_primary.prearranged_chambers = [1..num_prearranged].map{|i| PrearrangedChamber.create!}
    Rails.logger.error("#{@ensemble_primary.mmr_chambers.length} #{@ensemble_primary.prearranged_chambers.length}")
    
  end

  def create_chamber
    @ensemble_primary = EnsemblePrimary.find(params[:ensemble_primary])
    unless @ensemble_primary.update_attributes(post_params)
      railse "Problem with save"
    end
    redirect_to :action => :electives
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

