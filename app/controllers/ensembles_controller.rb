class EnsemblesController < ApplicationController

  include RegistrationGating

  before_filter :authorize, :only => [:primary]

  # Entry to the system, and presents the ensemble_primary form form with large ensemble choice that
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

  # Called when ensemble_primary form is submitted.  Presents chamber options
  def chamber
    @ensemble_primary = EnsemblePrimary.new(post_params)
    unless @ensemble_primary.save
      Rails.logger.error("Save on primary failed -- #{@ensemble_primary.error.full_messages}")
      raise e
    end
    num_mmr, num_prearranged = parse_chamber_music_choice(@ensemble_primary.chamber_ensemble_choice)
    num_mmr.times.each{|i| Rails.logger.error("Create in MMR"); MmrChamber.create!(:ensemble_primary_id => @ensemble_primary.id)}
    num_prearranged.times.each{|i| Rails.logger.error("Create in prearranged");PrearrangedChamber.create!(:ensemble_primary_id => @ensemble_primary.id)}
  end

  def create_chamber
    @ensemble_primary = EnsemblePrimary.find(params[:ensemble_primary][:id])
    
    params[:ensemble_primary][:mmr_chambers_attributes].values.each do |h| 
      raise "upate error" unless MmrChamber.find(h["id"].to_i).update_attributes(h)
    end
    params[:ensemble_primary][:prearranged_chambers_attributes].values.each do |h| 
      raise "upate error" unless PrearrangedChamber.find(h["id"].to_i).update_attributes(h)
    end

    raise "Problem with save" unless @ensemble_primary.update_attributes(post_params)

    flash[:ensemble_primary_id] = @ensemble_primary.id
    redirect_to :action => :electives
  end
      
  def electives
    @ensemble_primary = EnsemblePrimary.find(flash[:ensemble_primary_id])
    @electives = Elective.all
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
                                             :mmr_chambers,
                                             :prearranged_chambers
                                             )

  end
end

