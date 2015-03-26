class EnsemblesController < ApplicationController

  include RegistrationGating

  before_action :authorize
  before_action :set_user_or_handle_unauthorized

  def new
    @registration = @user.most_recent_registration
    unless @registration.instrument_id
      flash[:notice] = "You registered as a non-particpant -- no ensemble choice for you"
      redirect_to :controller => :registration, :action => :index
    else
      @ensemble_primary = @registration.ensemble_primaries.build
    end
  end

  def create
    @ensemble_primary = @user.most_recent_registration
      .ensemble_primaries.build(post_params)
    if @ensemble_primary.save
      session[:ensemble_primary_id] = @ensemble_primary.id
      redirect_to ensemble_steps_path
    else
      render :new
    end
  end

  def destroy
    @user.most_recent_registration
      .ensemble_primaries.find(params[:id]).destroy
    redirect_to registration_index_path
  end

  private

  def post_params
    params.require(:ensemble_primary).permit(
                                             :registration_id,
                                             :primary_instrument_id,
                                             :large_ensemble_choice,
                                             :large_ensemble_part,
                                             :chamber_ensemble_choice,
                                             :ack_no_morning_ensemble,
                                             :want_sing_in_chorus,
                                             :want_percussion_in_band,
                                             :mmr_chambers,
                                             :prearranged_chambers
                                             )

  end

  def set_user_or_handle_unauthorized
    if !session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :controller => :registration, :action => :index
    end

    @user = User.find(session[:user_id])

    if @user.nil?
      flash[:notice] = "Please log in first"
      redirect_to :controller => :registration, :action => :index
    elsif !@user.has_current_registration
      flash[:notice] = "You need to register first"
      redirect_to :controller => :registration, :action => :index
    end
  end
end
