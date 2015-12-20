class AdminController < ApplicationController

  include RegistrationGating

  before_filter :authorize_admin, 
  :only => [ :index, :new_user, :reset_password, :view_registration, :edit_registration, :list_registrations,
             :reg_invitation, :send_all_invitations, :send_early_invitations, :send_balance_reminders, :send_eval_reminders,
             :show_events, :delete_events, :list_scholarships, :list_online_payments ]

  before_filter :authorize_registrar, 
  :only => [ :add_payment, :delete_payment, :new_registration,
             :cancel_registration, :change_email, :drop_records ]

  def index
    # We should be able to count on a valid user here, but just in case...
    @admin_email = session[:user_id] && User.find_by_id(session[:user_id]) && User.find_by_id(session[:user_id]).email
  end

  def logout
    redirect_to(:controller => :login,  :action => :logout)
  end

  ############################
  #  User operations

  def reset_password
    session[:original_uri] = url_for(:controller => :admin, :action => :index)
    redirect_to(:controller => :login, :action => :reset_password)
  end

  def change_email
    session[:original_uri] = url_for(:controller => :admin, :action => :index)
    redirect_to(:controller => :login, :action => :change_email)
  end

  #############################
  #  New, cancel, edit registration
  
  #  For new registration, our entry screen is soliciting an email address.
  #  The registration controller checks that there's no existing registration.
  
  def new_registration
    if request.post? && params[:email] && params[:confirm_email]
      if params[:email] == params[:confirm_email]
        user = User.find_by_email(params[:email])
        user = User.create(:email => params[:email], :password => User.new_random_password(params[:email])) unless user
        session[:reg_form_callback] = [:admin, :index]
        redirect_to :controller => :registration, :action => :new, :user_id => user.id, :admin => true
      else
        flash[:notice] = "Email addresses do not match."
      end
    end
  end
  
  def view_registration
    session[:reg_form_callback] = [:admin, :list_registrations]
    redirect_to :controller => :registration, :action => :view, :id => params[:id]
  end
  
  def edit_registration
    session[:reg_form_callback] = [:admin, :list_registrations]
    redirect_to :controller => :registration, :action => :edit, :id => params[:id]
  end
  
  def cancel_registration
    reg = Registration.find(params[:id])
    name = reg.display_name
    reg.cancel
    Event.log("Cancelled registration #{params[:id]} for #{name}")
    flash[:notice] = "Registration for #{name} successfully cancelled"
    redirect_to :action => :list_registrations
  end

  ##############################################
  
  def list_registrations

    Event.log("Admin registration list")
    
    params[:sort_key]       = params[:sort_key]       || "sort_name" 
    params[:sort_direction] = params[:sort_direction] || "asc"

    @registrations = Registration.where(year: Year.this_year).to_a
    @registrations = @registrations.reject{|r|r.test} if Rails.env == "production"
    @registrations = Registration.sort(@registrations, params[:sort_key], params[:sort_direction])
    @reg_count = @registrations.size
  end

  def list_scholarships
    params[:sort_key] = "sort_name" unless params[:sort_key]
    params[:sort_direction] = "asc" unless params[:sort_direction]

    @registrations = Registration.find_all_by_year(Year.this_year).select{|reg|reg.scholarship?}.sort{|r1, r2| r1.display_name <=> r2.display_name}
    @reg_count = @registrations.size

  end

  #####################################
  ## TODO:  the test on p.registration was because when a registration was cancelled 
  ## but had a payment, it was referencing a null registration.  The problem is that 
  ## for whatever reason, the registration_id is not being instantiated in the cancellation 
  ## table, so we'll have to figure out a (manual) way to restore the payee information for
  ## those payments with null registrations.

  def list_online_payments
    @payments = Payment.find(:all, :conditions => 'online = 1').select{|p| p.registration && (p.registration.year == Year.this_year)}.sort_by(&:created_at)
  end

  #####################################
  ## Filemaker

  def file_maker
    @registration_last_download = Registration.last_download
    @registration_num_records_to_download = Registration.num_records_to_download
    @payment_last_download = Payment.last_download
    @payment_num_records_to_download = Payment.num_records_to_download

  end
  
  #######################################
  ##  Invitations and other emails

  #  This is entry point from the site -- send a new password no matter what	
  def reg_invitation
    if request.post?
      if (params[:email])
        if (params[:email] != params[:email_confirm])
          flash[:notice] = "Emails don't match; better try again"
        else
          email = params[:email]
          user = User.find_by_email(email)
          if user
            password = User.new_random_password(email)
            user.password = password
            RegistrationMailer.invitation_with_new_password(email, password)
            flash[:notice] = "Registration invitation sent to #{email}"
            Event.log("Admin invitation to #{email}")
            redirect_to(:controller => :admin, :action => :index)
          else
            password = User.new_random_password(email)
            user = User.new(:email => email, :password => password)
            unless user.save
              raise("Save failed on new user with #{email}!")
            end
            RegistrationMailer.invitation_with_new_password(email, password)
            Event.log("Individual invitation to new user #{email} with password #{password}")
            flash[:notice] = "Registration invitation sent to #{email}"
            redirect_to(:controller => :admin, :action => :index)
          end
        end
      end
    end
  end

  ##########################################################################
  #  Balance reminder (sent one week prior to June 1 payment deadline)

  def send_balance_reminders
    #test_emails = ["hanks.steve@gmail.com"]
    test_emails = nil
    rr = Registration.where(year: Year.this_year).select{|r|r.balance > 0}
    rr = rr.select{|r|test_emails.include?(r.email)} if test_emails
    rr.each{|r| RegistrationMailer.balance_reminder(r)}
    @emails = rr.map{|r|r.email}
  end

  def send_eval_reminders(testing=false)
    rr = []
    if testing
      test_emails = ["hanks.steve@gmail.com"]
      rr = Registration.where(year: Year.this_year).select{|r| test_emails.include?(r.email)}
    else
      rr = Registration.where(year: Year.this_year).reject{|r| r.has_complete_eval}.reject{|r|r.test}.reject{|r|!r.instrument_id}
    end
    rr.each{|r| RegistrationMailer.eval_reminder(r)}
    @emails = rr.map{|r|r.email}
  end

  #  Testing outbound email.  Delete me eventually.
  def send_test_email
    @email = "hanks@pobox.com"
    RegistrationMailer.test(@email)
  end

  #########################################################################################
  #  This is the bulk send near the end of the year.  Either populate the invitee table manually
  #  with email addresses, or it will be done for you.  By finding all Users whose emails have not 
  #  previously bounced.  
  #
  #   Note this may have to be run multiple times due to the Bluehost outbound email limit
  #

  def send_all_invitations

    if Invitee.count == 0
      User.all.reject{|u|u.bounced_at}.each{|u|Invitee.create(:email => u.email)}
    end
    
    limit = 100

    invitees = Invitee.all.reject{|i| i.sent}
    invitees = invitees[0..limit-1] if invitees.size > limit

    @sent = []
    @skipped = []

    invitees.each do |invitee|

      email = invitee.email

      if invitee.sent?
        Event.log("Skipped #{email} due to already sent")
        @skipped << email
        next
      end

      if email =~ /musicalretreat.org/
        Event.log("Skipped #{email} due to internal")
        @skipped << email
        next
      end
      
      user = User.find_by_email(email)
      unless user
        Event.log("PAY ATTENTION!  SKIPPED #{email} ALTOGETHER BECAUSE OF NO ACCOUNT")
        next
      end

      if user.has_current_registration 
        Event.log("Skipped #{email} due to existing registration")
        @skipped << email
      elsif user.bounced_at
        Event.log("Skipped #{email} due to bounceage")
        @skipped << email
      else 
        RegistrationMailer.invitation(user)
        Event.log("Bulk invitation to user #{email}")
        @sent << email
        invitee.sent = true
        invitee.save!
      end
    end
    @remaining = Invitee.all.reject{|r|r.sent}.size
  end

  #  This is to the early invitees.  Use the list in the registration gating module directly.

  def send_early_invitations
    RegistrationGating.early_invitees.each{|email| RegistrationMailer.early_invitation(email)}
    @sent = RegistrationGating.early_invitees.size
  end

  def send_self_eval_invitations

    if Invitee.count == 0
      User.all.reject{|u|u.bounced_at}.each{|u|Invitee.create(:email => u.email)}
    end
    
    limit = 35

    invitees = Invitee.all.reject{|i| i.sent}
    invitees = invitees[0..limit-1] if invitees.size > limit

    @sent = []
    @skipped = []

    invitees.each do |invitee|
      email = invitee.email
      if invitee.sent?
        Event.log("Skipped #{email} due to already sent")
        @skipped << email
        next
      end
      user = User.find_by_email(email)
      unless user
        Event.log("PAY ATTENTION!  SKIPPED #{email} ALTOGETHER BECAUSE OF NO ACCOUNT")
        next
      end

      # NB -- the call to ensemble_primaries_complete? will actually
      # blow away any incomplete ensemble primaries -- so it will suck
      # to send the invitation at the time the user is actually filling
      # out the form.  

      # TODO:  uncomment this for production, though it probably should be OK anyway

      # if !user.has_current_registration 
      #    Event.log("Skipped #{email} due to no existing registration")
      #    @skipped << email
      # elsif user.current_registration.ensemble_primaries_complete?
      #   Event.log("Skipped #{email} due to no existing registration")
      #   @skipped << email
      # elsif user.bounced_at
      #   Event.log("Skipped #{email} due to bounceage")
      #   @skipped << email
      # else 
      RegistrationMailer.self_eval_invitation(user)
      Event.log("Bulk invitation to user #{email}")
      @sent << email
      invitee.sent = true
      invitee.save!
      # end
    end
    @remaining = Invitee.all.reject{|r|r.sent}.size
  end

  ####################################################################
  ## Drop Registration and Payment records, which are then picked up 

  def drop_records
    @registration_count = Registration.dump_records
    @payment_count = Payment.dump_records
    sleep(5)
  end

  ####################################################################
  ##  This shows and clears the event trace
  
  def show_events
    @events = Event.order("created_at").to_a
  end
  
  def delete_events
    Event.delete_all
  end

  def clear_events
    Event.delete_all
  end


  ################################################################
  private

  def user_post_params
    params.require(:user).permit(:email, :password)
  end
end
