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
    @primary_registrations = Registration.joins(:instrument).where(instruments: {instrument_type: params[:type]})
    @secondary_registrations = Registration.joins(ensemble_primaries: {evaluations: :instrument}).where(instruments: {instrument_type: params[:type]})
    if params[:type] == 'string'
      @primary_registrations += Registration.where(instrument_id: 34)
      @secondary_registrations += Registration.joins(ensemble_primaries: :evaluations).where(evaluations: {instrument_id: 34})
    end
    @secondary_registrations -= @primary_registrations
    @concantated_registrations = @primary_registrations + @secondary_registrations
  end
end
