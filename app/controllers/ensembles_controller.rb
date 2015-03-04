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
    @instrument_name = Instrument.find(@registration.instrument_id).display_name
    @ensemble_primary = EnsemblePrimary.new
  end

end

