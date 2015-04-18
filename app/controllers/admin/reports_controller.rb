class Admin::ReportsController < ApplicationController
  include RegistrationGating
  before_filter :authorize_admin
  layout 'admin'

  def show
    @registration = Registration.find(params[:id])
    render :show, locals: { registration: @registration }
  end

  def chose
  end

  def section_index
    @primary_registrations = Registration.joins(:ensemble_primaries).joins(:instrument).where(instruments: {instrument_type: params[:type]}).where(ensemble_primaries: {complete: true})
    @secondary_registrations = Registration.joins(ensemble_primaries: {evaluations: :instrument}).where(instruments: {instrument_type: params[:type]}).where(ensemble_primaries: {complete: true}).uniq
    @secondary_registrations -= @primary_registrations
    @concantated_registrations = @primary_registrations + @secondary_registrations
  end

  def elective_index
    @elective = Elective.find(params[:elective_id])
    @ensemble_primaries = @elective.ensemble_primaries.completed
  end

  def prearranged_index
    @prearranged_chambers = PrearrangedChamber.joins(:ensemble_primary).order('prearranged_chambers.i_am_contact desc').where(ensemble_primaries: {complete: true})
  end
end
