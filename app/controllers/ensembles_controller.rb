class EnsemblesController < ApplicationController

  include RegistrationGating

  # This is the entry point
  def choose
    @registration = User.find(session[:user_id]).current_registration
  end
  
end

