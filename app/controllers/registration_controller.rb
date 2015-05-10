require 'registration_gating'

class RegistrationController < ApplicationController

  include RegistrationGating

  before_filter :authorize, :only => [:create, :new, :show, :payment, :edit, :update]
  before_filter :authorize_admin, :only => [:destroy]

  ############################################################################  

  def index
    # Registration system status
    @status = registration_system_status
    @can_register = can_register
    @can_pay = can_pay

    # This user's status
    @logged_in = session_user
    @email = session_email
    @registration = session_registration
    @registered = !@registration.nil?
    @has_balance = @registration && @registration.balance > 0
    @needs_evals = @registration && @registration.ensemble_primaries_incomplete?
  end

  ####################################################
  #  New/create
  #   Need a user_id -- either use the session user_id, or admin controller will pass one explicitly

  def new
    user = nil
    if params[:user_id]
      redirect_to(:controller => :registration, :action=> :index) unless admin_session?
      user = User.find(params[:user_id])
      unless user
        flash[:notice] = "No user with this ID found!"
        redirect_to(:controller => :admin, :action=> :index)
      end
    else
      user = User.find(session[:user_id])
    end
    if user.has_current_registration
      flash[:notice] = "User #{user.email} is already registered"
      reg_redirect
    else
      session[:registration] = @registration = Registration.populate(user)
      @admin_session = admin_session?
    end
  end

  def create
    verify_admin_or_self(params[:registration][:user_id])
    admin = params[:registration][:user_id] && session[:user_id] && (params[:registration][:user_id].to_i != session[:user_id])

    @registration = Registration.new(post_params)
    if Registration.find_by_user_id_and_year(@registration.user_id, @registration.year)
      flash[:notice] = "We already have a registration for #{@registration.user.email}"
      redirect_to :controller => (admin ? :admin :registration) , :action => :index
    elsif @registration.save
      FileMakerContact.setContactID(@registration)
      Event.log("New registration created for #{@registration.user.email}")
      if admin
        flash[:notice] = "New registration successful"
        redirect_to :controller => :admin, :action => :index
      else
        RegistrationMailer.confirm_registration(@registration)
        flash[:notice] = "New registration successful"
        if @registration.payment_mode =~ /check/
          redirect_to :controller => :registration, :action => :index
        else
          redirect_to :controller => :cc, :action => :depart, :id => @registration.id
        end
      end
    else
      render :action => :new
    end
  end
  
  #################################################################################
  # Edit/update -- like new/create, two entry points, 
  #  one from the user via registration controller and from admin via admin controller
  #  In the first case, user/reg of the logged in user is same as reg to be edited.  Not in the second, 
  #  where the call should send a user_id

  def edit
    user_id = params[:id].to_i > 0 ? params[:id] : session[:user_id]
    registration = nil
    if params[:id]
      redirect_to(:controller => :registration, :action=> :index) unless admin_session?
      registration = User.find(params[:id]).current_registration
      unless registration
        flash[:notice] = "No registration to edit!"
        redirect_to(:controller => :admin, :action=> :index)
      end
    else
      registration = User.find(session[:user_id]).current_registration
      unless registration 
        flash[:notice] = "No registration to edit!"
        redirect_to(:controller => :registration, :action=> :index)
      end
    end
    session[:registration] = @registration = registration
    @admin_session = admin_session?
  end

  def update
    verify_admin_or_self(params[:registration][:user_id])
    controller = admin_session? ? :admin : :registration
    user_id_mismatch = params[:registration][:user_id].to_i != session[:user_id]

    @registration = Registration.find(params[:registration][:id])

    if user_id_mismatch && !admin_session?
      flash[:notice] = "Cannot update this registration."
      redirect_to :controller => :registration, :action => :index
    else
      if @registration.update_attributes(post_params)
        flash[:notice] = "Update was successful"
        redirect_to :controller => controller, :action => :index
      else
        render :action => :edit
      end
    end
  end

  ##########
  
  def show
    user_id = params[:id].to_i > 0 ? params[:id] : session[:user_id]
    verify_admin_or_self(user_id)
    @registration = Registration.find_by_user_id_and_year(user_id, Year.this_year)
    if (!@registration)
      flash[:notice] = "No registration found"
      redirect_to :action => :index
    end
  end

  ##########
  
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
  #  wine_glasses (dropdown)
  #  tshirts, tshirtm, tshirtl, tshirtxl, tshirtxxl, tshirtxxxl (dropdown)
  #
  #  If you add to this list, remember to update routes.rb as well!

  def update_dorm_selection; update_field("dorm_selection"); end
  def update_sunday; update_field("sunday"); end
  def update_single_room; update_field("single_room"); end
  def update_participant; update_field("participant"); end
  def update_meals_selection; update_field("meals_selection"); end
  def update_donation; update_field("donation"); end
  def update_wine_glasses; update_field("wine_glasses"); end
  def update_tshirts; update_field("tshirts"); end
  def update_tshirtm; update_field("tshirtm"); end
  def update_tshirtl; update_field("tshirtl"); end
  def update_tshirtxl; update_field("tshirtxl"); end
  def update_tshirtxxl; update_field("tshirtxxl"); end
  def update_tshirtxxxl; update_field("tshirtxxxl"); end
  def update_payment_mode; update_field("payment_mode"); end

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
    params.require(:registration).permit(:id, :user_id, :year, 
                                         :payment_mode, :gender, :first_name, :last_name, 
                                         :street1, :street2, :city, :state, :zip, :country, 
                                         :occupation, :emergency_contact_name, :emergency_contact_phone, 
                                         :home_phone, :cell_phone, :work_phone, 
                                         :comments, :firsttime, :mailinglist, :donotpublish,
                                         :participant, :instrument_id, :meals_selection, :vegetarian, :airport_pickup, 
                                         :dorm_selection, :dorm_assignment, :single_room, :aircond, :fan, :handicapped_access, 
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
