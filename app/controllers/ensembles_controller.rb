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
    else
      flash[:notice] = "Primary ensemble saved FAILED"
    end
    redirect_to :controller => :registration, :action => :index
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

