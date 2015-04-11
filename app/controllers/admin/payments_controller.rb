class Admin::PaymentsController < ApplicationController
  include RegistrationGating
  before_filter :authorize_admin

  def index
    respond_to do |format|
      format.text do
        send_data Payment.list, filename: "payments-#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.txt"
      end
    end
  end
end
