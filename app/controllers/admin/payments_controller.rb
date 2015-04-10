class Admin::PaymentsController < ApplicationController
  include RegistrationGating
  before_filter :authorize_admin
  before_filter :authorize_registrar, except: :index
  before_action :set_registration, except: :index
  layout 'admin'

  def index
    respond_to do |format|
      format.text do
        send_data Payment.list, filename: "payments-#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.txt"
      end
    end
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = @registration.payments.build(payment_params)
    @payment.date_received = Date.today

    if @payment.save
      RegistrationMailer.confirm_payment(@payment) if @payment.send_confirm_email
      flash[:notice] = sprintf("Payment of \$%6.2f recorded for %s", @payment.amount, @payment.registration.email)
      Event.log("Admin created payment for #{@payment.registration.email} amount #{@payment.amount}")
      redirect_to '/admin/list_registrations'
    else
      render :new, registration_id: @registration.id
    end
  end

  def edit
    @payments = @registration.payments
    @payment = @payments.where(id: params[:id]).first
  end

  def update
    @payments = @registration.payments
    @payment = @payments.where(id: params[:id]).first
    if @payment.update_attributes(payment_params)
      flash[:notice] = sprintf("Payment of \$%6.2f updated for %s", @payment.amount, @payment.registration.email)
      Event.log("Admin updated payment for #{@payment.registration.email} amount #{@payment.amount}")
      redirect_to '/admin/list_registrations'
    else
      render :edit, registration_id: @registration.id, id: @payment
    end
  end

  def destroy
    payment = @registration.payments.where(id: params[:id]).first
    reg_id = @registration.id
    user_id = @registration.user.id
    payment.destroy
    flash[:notice] = sprintf("Payment of \$%6.2f removed for %s", payment.amount, payment.registration.email)
    Event.log("Deleted payment #{payment.id} in amount of #{payment.amount} for registration #{reg_id}, user #{user_id}")
    redirect_to '/admin/list_registrations'
  end

  private

  def payment_params
    params.require(:payment).permit(:registration_id, :amount, :check_number, :date_received, :note, :scholarship, :email)
  end

  def set_registration
    @registration = Registration.find(params[:registration_id])
  end
end
