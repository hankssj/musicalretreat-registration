class EnsemblesController < ApplicationController

  include RegistrationGating

  before_action :authorize
  before_action :set_user_or_handle_unauthorized

  def reselect
    Rails.logger.warn("Ensemble reselect on #{@user.most_recent_registration.id}")
    @user.most_recent_registration.ensemble_primaries.each do |e|
      Rails.logger.warn("Destroying EP  #{e.id}")
      e.destroy
    end
    redirect_to action: :new
  end

  def new
    @registration = @user.most_recent_registration
    Rails.logger.warn("Ensemble new on user #{@user.id} registration #{@registration.id}")
    unless @registration.instrument_id
      Rails.logger.warn("#{@user.id} is a non-participant, bailing")
      flash[:notice] = "You registered as a non-particpant -- no ensemble choice for you"
      redirect_to :controller => :registration, :action => :index
    else
      @ensemble_primary = @registration.ensemble_primaries.build
      Rails.logger.warn("Created EP #{@ensemble_primary.id} for reg #{@registration.id}")
    end
  end

  def create
    @ensemble_primary = @user.most_recent_registration.ensemble_primaries.build(post_params)
    Rails.logger.warn("Ensemble create on registration #{@user.most_recent_registration.id} ensemble #{@ensemble_primary.id}")
    if @ensemble_primary.save
      Rails.logger.warn("Ensemble create save suceeds reg #{@user.most_recent_registration.id} ensemble #{@ensemble_primary.id}")
      session[:ensemble_primary_id] = @ensemble_primary.id
      redirect_to ensemble_steps_path
    else
      Rails.logger.warn("Ensemble save fails reg #{@user.most_recent_registration.id} ensemble #{@ensemble_primary.id}")
      render :new
    end
  end

  def destroy
    Rails.logger.warn("Ensemble destroy registration #{@user.most_recent_registration.id}")
    @user.most_recent_registration.ensemble_primaries.each do |e| 
      Rails.logger.warn("Ensemble Destroy ep #{e.id}")
      e.destroy
    end
    redirect_to registration_index_path
  end

  def finish
    set_user_or_handle_unauthorized
    registration = @user.most_recent_registration
    Rails.logger.warn("Ensemble finish on user #{@user.id}")
    if registration.nil? 
      Rails.logger.warn("Ensemble finish on user #{@user.id} failed, no registration")
      flash[:notice] = "Error finishing ensemble: no registration"
    elsif !registration.ensemble_primaries || registration.ensemble_primaries.empty?
      Rails.logger.warn("Ensemble finish on user #{@user.id} failed, no ensemble record")
      flash[:notice] = "Error finishing ensemble: no ensemble record"
    elsif params[:commit] == 'FINISH'
      flash[:notice] = "Ensemble and elective choices complete"
      ep = registration.ensemble_primaries.first
      ep.update_attributes(post_params)
      ep.complete = true
      ep.save!      
      Rails.logger.warn("Ensemble finish EP saved, user is #{@user.id} ep is #{ep.id}")
      registration.minor_volunteer = params[:minor_volunteer]
      registration.save!
    elsif params[:commit] == 'CANCEL'
      Rails.logger.warn("Ensembled finish cancelled, user is #{@user.id}")
      flash[:notice] = "Ensemble choice cancelled"
      registration.ensemble_primaries.first.destroy
    elsif params[:ensemble_primary] 
      Rails.logger.warn("Got finish without a commit param; acting like it is a save, user #{@user.id}")
      flash[:notice] = "Ensemble and elective choices complete"
      ep = registration.ensemble_primaries.first
      ep.update_attributes(post_params)
      ep.complete = true
      ep.save!      
      registration.minor_volunteer = params[:minor_volunteer]
      registration.save!
    else
      Rails.logger.fatal("Problem in ensemble finish with user #{@user.id} params #{params}")
    end
    redirect_to controller: :registration, action: :index
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
                                             :prearranged_chambers, 
                                             :comments,
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
