class AdminController < ApplicationController

  include RegistrationGating

  before_filter :authorize_admin, 
  :only => [ :index, :new_user, :reset_password, :view_registration, :edit_registration, :list_registrations,
             :reg_invitation, :send_all_invitations, :send_early_invitations, :send_balance_reminders, 
             :send_self_eval_reminders, :send_registration_summary,
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
    #test_emails = ["hanks@pobox.com"]
    test_emails = nil
    rr = Registration.where(year: Year.this_year).select{|r|r.balance > 0}
    rr = rr.select{|r|test_emails.include?(r.email)} if test_emails
    rr.each do |r| 
      u = r.user
      if u.bounced_at
        puts("Found bounced email #{u.email} in sending balance reminder")
      else
        begin
          RegistrationMailer.balance_reminder(r)
          puts("Succeeded on #{u.email}")
        rescue => e
          puts("Failed on #{u.email} due to #{e}")
          Rails.logger.error("Send balance throws #{e}, skipping #{u.email}")
        end
      end
    end
  end

#######################################################
#  Sent around July 1 to all campers -- has dorm assigment, balance reminder,
#  other instructions

  def send_registration_summary
    #test_emails = ["hanks@pobox.com"]
    test_emails = nil
    rr = Registration.where(year: Year.this_year)
    rr = rr.select{|r|test_emails.include?(r.email)} if test_emails
    rr.each do |r| 
      u = r.user
      if u.bounced_at
        puts("Found bounced email #{u.email} in sending registration reminder")
      else
        begin
          RegistrationMailer.registration_summary(r)
          puts("Succeeded on #{u.email}")
        rescue => e
          puts("Failed on #{u.email} due to #{e}")
          Rails.logger.error("Send registration reminder throws #{e}, skipping #{u.email}")
        end
      end
    end
  end

#########################################

  #  Testing outbound email.  Delete me eventually.
  def send_test_email
    @email = "hanks@pobox.com"
    RegistrationMailer.test(@email)
  end

  #########################################################################################
  #  This is the bulk send near the end of the year.  Either populate the invitee table manually
  #  with email addresses, or it will be done for you.  By finding all Users whose emails have not 
  #  previously bounced.  

  def send_all_invitations
    uu = User.all.reject{|u| u.bounced_at || u.test || u.email =~ /musicalretreat.org/ || u.has_current_registration}
    Rails.logger.info("Going to send #{uu.size} invitations")
    uu.each do |u|
      begin
        RegistrationMailer.invitation(u)
        Rails.logger.info("Successfully sent to #{u.email}")
      rescue StandardError => e
        Rails.logger.error("Failed to send to #{u.email} due to #{e}")
      end
    end
  end

  # def send_all_invitations

  #   if Invitee.count == 0
  #     User.all.reject{|u|u.bounced_at}.reject{|u|u.test}.each{|u|Invitee.create(:email => u.email)}
  #   end
    
  #   limit = 10000

  #   invitees = Invitee.all.reject{|i| i.sent}
  #   invitees = invitees[0..limit-1] if invitees.size > limit

  #   @sent = []
  #   @skipped = []

  #   invitees.each do |invitee|

  #     email = invitee.email

  #     if invitee.sent?
  #       Event.log("Skipped #{email} due to already sent")
  #       @skipped << email
  #       next
  #     end

  #     if email =~ /musicalretreat.org/
  #       Event.log("Skipped #{email} due to internal")
  #       @skipped << email
  #       next
  #     end
      
  #     user = User.find_by_email(email)
  #     unless user
  #       Event.log("PAY ATTENTION!  SKIPPED #{email} ALTOGETHER BECAUSE OF NO ACCOUNT")
  #       next
  #     end

  #     if user.has_current_registration 
  #       Event.log("Skipped #{email} due to existing registration")
  #       @skipped << email
  #     elsif user.bounced_at
  #       Event.log("Skipped #{email} due to bounceage")
  #       @skipped << email
  #     else 
  #       RegistrationMailer.invitation(user)
  #       Event.log("Bulk invitation to user #{email}")
  #       @sent << email
  #       invitee.sent = true
  #       invitee.save!
  #     end
  #   end
  #   @remaining = Invitee.all.reject{|r|r.sent}.size
  # end

  ###############################
  #  This should replace send_all_invitations if we decide the registration will go to the mass email list, 
  #  and not just to the User list.  But if so we should make sure all new Users get on the mass email list.

  def send_mass_email_invitations
    MassEmail.all.reject{|m| m.bounced_at || m.unsubscribed_at}.each do |m|
      begin
        puts m.email_address
        RegistrationMailer.mass_email_invitation(m.email_address, m.url_code)
      rescue StandardError => e
        puts "Failed on email #{m.email_address} due to #{e}"
        m.bounced_at = Time.now
        m.save!
      end
    end
  end

  def send_mass_email_generics
    MassEmail.all.reject{|m| m.bounced_at || m.unsubscribed_at}.each do |m|
      begin
        RegistrationMailer.mass_email_generic(m.email_address, m.url_code)
        puts "#{m.email_address} #{m.url_code}"
      rescue StandardError => e
        Rails.logger.fatal("Mass email generic attempt failed on email #{m.email_address} due to #{e}")
        m.bounced_at = Time.now
        m.save!
      end
    end
  end

  def send_faculty_registration_invitations
    User.all.select{|u| u.faculty && !u.bounced_at}.each do |user|
      begin
        puts user.email
        RegistrationMailer.faculty_registration_invitation(user.email)
      rescue StandardError => e
        puts "Failed on email #{user.email} due to #{e}"
        user.bounced_at = Time.now
        user.save!
      end
    end
  end

  ############################################
  #  This is to the early invitees.  Use the list in the registration gating module directly.

  def send_early_invitations
    RegistrationGating.early_invitees.each{|email| RegistrationMailer.early_invitation(email)}
    @sent = RegistrationGating.early_invitees.size
  end

  # Send to all users that have current registration and are a participant, and do not have a complete eval already

  ## TODO:  looks like a bounce throws an exception.  Need to harden off all of these send methods.

  def send_self_eval_invitations
    users = User.all.select{|u| 
      u.has_current_registration && 
      u.current_registration.participant && 
      !u.faculty && 
      !u.test && 
      !u.current_registration.has_complete_eval
    }
     users.each do |u| 
      if u.bounced_at 
        Rails.logger.error("Found bounced email #{u.email} in sending self eval_reminder")
      else
        begin
          RegistrationMailer.self_eval_invitation(u)
          puts("Succeed on #{u.email}")
        rescue => e
          puts("Failed on #{u.email}")
          Rails.logger.error("Send eval throws #{e}, skipping #{u.email}")
        end
      end
    end
  end
  
## TODO:  get rid of print statements
  def send_self_eval_reminders
    users = User.all.select{|u| u.has_current_registration && u.current_registration.participant && !u.current_registration.has_complete_eval}
    @sent = []
    users.each do |u| 
      if u.bounced_at 
        Rails.logger.error("Found bounced email #{u.email} in sending self eval_reminder")
      else
        begin
          RegistrationMailer.self_eval_reminder(u)
          puts("Succeed on #{u.email}")
          @sent << u.email
        rescue => e
          puts("Failed on #{u.email}")
          Rails.logger.error("Send eval throws #{e}, skipping #{u.email}")
        end
      end
    end
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
