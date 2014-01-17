require 'registration_gating'

class RegistrationController < ApplicationController

  include RegistrationGating

  before_filter :authorize, :only => [:create, :new, :show, :payment]
  before_filter :authorize_admin, :only => [:edit, :update, :destroy]

  ############################################################################  

  def index
    @email = session_email
    @status = status
    @can_register = can_register
    @can_pay = can_pay
  end

  def begin
    @email = session_email
    @status = status
    @can_register = can_register
  end

  ####################################################

  # Form to fill out a new registration
  def new
    user = User.find(session[:user_id])
    if user.has_current_registration
      flash[:notice] = "User #{user.email} is already registered"
      reg_redirect
    else
      session[:registration] = @registration = Registration.populate(user)
    end
  end

  # Save the new registration
  def create
    verify_admin_or_self(params[:registration][:user_id])
    @registration = Registration.new(post_params)
    if Registration.find_by_user_id_and_year(@registration.user_id, @registration.year)
      flash[:notice] = "We already have a registration for #{@registration.user.email}"
      redirect_to :action => :index
    elsif @registration.save
      FileMakerContact.setContactID(@registration)
      Event.log("New registration created for #{@registration.user.email}")
      RegistrationMailer.confirm_registration(@registration)
      if @registration.payment_mode =~ /check/
        flash[:notice] = "New registration successful"
        @email = @registration.user.email
        @cart = @registration.cart
      else
        redirect_to :controller => :cc, :action => :depart, :id => @registration.id
      end
    else
      render :action => :new
    end
  end
  
  ##########
  
  def show
    user_id = params[:id].to_i > 0 ? params[:id] : session[:user_id]
    verify_admin_or_self(user_id)
    @registration = Registration.find_by_user_id_and_year(user_id, Year.this_year)
    @readonly = true
    if (!@registration)
      flash[:notice] = "No registration found"
      redirect_to :action => :index
    end
  end
  
  ##########
  ##  For now we are not allowing users to edit, so all calls must come 
  ##  with an ID, and be administrator validated
  
  def edit
    if request.post? && params[:registration]
      verify_admin_or_self(params[:registration][:user_id])
      reg = User.find(params[:registration][:user_id]).current_registration
      if reg.update_attributes(params[:registration])
        flash[:notice] = "Edit successful"
        reg_redirect(:index)
      else
        flash[:notice] = "Error updating"
        @registration = Registration.new(params[:registration])
        @regform_type = :edit
      end
    else
      user_id = params[:id]    #  No session[:user_id]
      verify_admin_or_self(user_id)
      @registration = User.find(user_id).current_registration
      if @registration
        @regform_type = :edit
      else
        reg_redirect(:index, "No registration to edit")
      end
    end
  end
  
  ##  Helpers for new/edit/view

  def verify_admin_or_self(id_string)
    id = id_string.to_i
    return false if id == 0 || session[:user_id] == 0
    user = User.find_by_id(session[:user_id])
    return true if user && (user.admin || user.id == id)
    raise "ID mismatch -- ID passed in is #{id};  session says #{session[:user_id]};  user is #{user} with ID #{user.id}"
  end

  ############################################################
  #  Updater methods for each control on the registration form that should trigger an 
  #  update to the cart.  These are:  
  #  participant (radio button)
  #  dorm_selection (radio button) values d (double occupancy), s (single occupancy request), n (none)
  #  meals_selection (radio button, values  f (full), l (lunch), n (none)
  #  donation (dropdown)
  #  tshirts, tshirtm, tshirtl, tshirtxl, tshirtxxl, tshirtxxxl (dropdown)

  def update_dorm_selection; update_field("dorm_selection"); end
  def update_sunday; update_field("sunday"); end
  def update_single_room; update_field("single_room"); end
  def update_participant; update_field("participant"); end
  def update_meals_selection; update_field("meals_selection"); end
  def update_donation; update_field("donation"); end
  def update_tshirts; update_field("tshirts"); end
  def update_tshirtm; update_field("tshirtm"); end
  def update_tshirtl; update_field("tshirtl"); end
  def update_tshirtxl; update_field("tshirtxl"); end
  def update_tshirtxxl; update_field("tshirtxxl"); end
  def update_tshirtxxxl; update_field("tshirtxxxl"); end

  def update_field(field_name)
    new_value = params["registration"] && params["registration"][field_name] ? params["registration"][field_name] : false
    session[:registration].send("#{field_name}=", new_value)
    @cart = session[:registration].cart
    respond_to do |format|
      format.js {render :update_cart}
    end
  end

  private
  
  def post_params
    params.require(:registration).permit(:user_id, :year, 
                                         :payment_mode, :gender, :first_name, :last_name, 
                                         :street1, :street2, :city, :state, :zip, :country, 
                                         :occupation, :emergency_contact_name, :emergency_contact_phone, 
                                         :home_phone, :cell_phone, :work_phone, 
                                         :comments, :firsttime, :mailinglist, :donotpublish,
                                         :participant, :instrument_id, :meals_selection, :vegetarian, :airport_pickup, 
                                         :dorm_selection, :single_room, :aircond, :fan, :handicapped_access, 
                                         :share_housing_with,
                                         :sunday, :donation, :wine_glasses,
                                         :tshirts, :tshirtm, :tshirtl, :tshirtxl, :tshirtxxl, :tshirtxxxl)
  end

  #  Caller may put a controller/action pair in the session -- if so, 
  #  go there.  Otherwise go somewhere in the current controller
  
  def reg_redirect(action = :index, notice = nil)
    flash[:notice] = notice if notice
    if session[:reg_form_callback]
      controller = session[:reg_form_callback][0]
      action = session[:reg_form_callback][1]
      session[:reg_form_callback] = nil
      redirect_to  :controller => controller, :action => action
    else
      redirect_to :action => action
    end
  end
  
  #######################################################
  public

  def payment
    user = User.find(session[:user_id])
    if !user
      flash[:notice] = "Not logged in"
      redirect_to :action => :index
    elsif !user.has_current_registration
      flash[:notice] = "You are not currently registered"
      redirect_to :action => :index
    elsif user.current_registration.balance == 0
      flash[:notice] = "No balance to pay"
      redirect_to :action => :index
    elsif params[:type]
      @registration = Registration.find(params[:id])
      @registration = user.current_registration
      if params[:type] == "deposit"
        @registration.payment_mode = "deposit_cc"
      else 
        @registration.payment_mode = "balance_cc"
      end
      @registration.save!
      redirect_to( :controller => :cc, :action => :depart, :id => @registration.id)
    else
      @registration = user.current_registration
    end
  end

  def confirm_registration
    user = User.find(session[:user_id])
    if user && user.has_current_registration
      @registration = user.most_recent_registration
      @email = user.email
      @cart = @registration.cart
      Event.log("#{user.email} confirmed")
    else
      flash[:notice] = "You do not have a current registration"
      Event.log("#{user.email} tried to confirm but no registration")
      redirect_to :action => "index"
    end
  end

  #######################################################
  
  def new_password
    session[:original_uri] = url_for(:controller => :registration, :action => :index)
    redirect_to(:controller => :login, :action => :new_password)
  end

  def change_password
    session[:original_uri] = url_for(:controller => :registration, :action => :index)
    redirect_to(:controller => :login, :action => :change_password)
  end
  
  def paper_form
    redirect_to("http://musicalretreat.org/docs/registration.pdf")
  end
  
  def login
    session[:original_uri] = nil
    session[:login_type] = :normal
    redirect_to(:controller => :login, :action => :login)
  end

  def logout
    session[:original_uri] = nil
    redirect_to(:controller => :login, :action => :logout)
  end

  def done
    session[:original_uri] = nil
    redirect_to(:controller => :login, :action => :logout)
  end
end
