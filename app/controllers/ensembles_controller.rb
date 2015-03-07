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
  
  def create_ensemble_primary
    @ensemble_primary = EnsemblePrimary.new(post_params)
    if @ensemble_primary.save
      flash[:notice] = "Primary ensemble saved OK"
      flash[:ensemble_primary_id] = @ensemble_primary.id
      #redirect_to :action => chamber
    else
      Rails.logger.error("Save on primary failed -- #{@ensemble_primary.error.full_messages}")
      raise e
    end
  end

  def chamber
    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id].to_i)
    @primary_instrument_id = @ensemble_primary.registration.instrument_id
    chamber_choice = @ensemble_primary.chamber_ensemble_choice
    @num_mmr = @num_prearranged = nil
    @num_mmr = 0 if [0, 2, 5, 6].include? chamber_choice
    @num_mmr = 1 if [1, 4].include? chamber_choice
    @num_mmr = 2 if [3].include? chamber_choice
    @num_prearranged = 0 if [0, 1, 3].include? chamber_choice
    @num_prearranged = 1 if [2, 4, 5].include? chamber_choice
    @num_prearranged = 2 if [6].include? chamber_choice
    Rails.logger.info("Ensemble ID #{@ensemble_primary.id}")
    Rails.logger.info("Primary inst ID #{@primary_instrument_id}")
    Rails.logger.info("Chamber choice #{chamber_choice}")
    raise "Problem with chamber count" unless @num_mmr && @num_prearranged
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
                                             )

  end
end

