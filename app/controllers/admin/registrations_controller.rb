class Admin::RegistrationsController < ApplicationController
  include RegistrationGating
  before_filter :authorize_admin

  def index
    respond_to do |format|
      format.text do
        send_data Registration.list, filename: "registrations-#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.txt"
      end
    end
  end
end


