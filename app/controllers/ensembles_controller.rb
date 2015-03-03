class EnsemblesController < ApplicationController

  include RegistrationGating

  # This is the entry point
  def primary_ensemble
    @registration = User.find(session[:user_id]).current_registration
    @instrument_name = @registration.instrument.display_name
  end
  
end

