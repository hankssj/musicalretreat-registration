class Admin::ReportsController < ApplicationController
  include RegistrationGating
  before_filter :authorize_admin, :except => [:show]
  layout 'admin'

  def show
    @registration = Registration.find(params[:id])
    render :show, locals: { ensemble_primary: @registration.ensemble_primary }
  end

  def chose
  end

  def section_index
    @primary_registrations = Registration.where(year: Year.this_year).joins(:ensemble_primaries).joins(:instrument).where(instruments: {instrument_type: params[:type]}).where(ensemble_primaries: {complete: true}).all
    @primary_registrations = @primary_registrations.sort{|r1, r2| r1.instrument.display_name <=> r2.instrument.display_name}
    @secondary_registrations = Registration.where(year: Year.this_year).joins(ensemble_primaries: {evaluations: :instrument}).where(instruments: {instrument_type: params[:type]}).where(ensemble_primaries: {complete: true}).all.uniq
    @secondary_registrations = @secondary_registrations.sort{|r1, r2| r1.instrument.display_name <=> r2.instrument.display_name}
    @secondary_registrations -= @primary_registrations
    @concantated_registrations = @primary_registrations + @secondary_registrations
    render layout: "reports"
  end

  def elective_index
    @elective = Elective.find(params[:elective_id])
    @ensemble_primaries = @elective.ensemble_primaries.all.select{|e|e.year == Year.this_year && e.complete}
    render layout: "reports"
  end

#   def prearranged_index
# P    @prearranged_chambers = PrearrangedChamber.where(year: Year.this_year).joins(:ensemble_primary).order('prearranged_chambers.i_am_contact desc').where(ensemble_primaries: {complete: true})
#     render layout: "reports"
#   end

  def prearranged_index
    @prearranged_chambers = PrearrangedChamber.all.select{|p| p.year == Year.this_year && p.ensemble_primary.complete}
    @prearranged_chambers = @prearranged_chambers.partition{|p| p.i_am_contact}.flatten
    render layout: "reports"
  end

end
