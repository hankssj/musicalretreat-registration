class Admin::RegistrationsController < ApplicationController
  include RegistrationGating
  before_filter :authorize_admin

  def index
    @registrations = Registration.all
    render pdf: "mmr_report_#{DateTime.now.strftime('%H_%M_%d_%m_%Y')}",
      layout: 'application.pdf'
  end
end
