class LoginController < ApplicationController

  def login
    session[:user_id] = nil
    type = session[:login_type]

    if request.post? && params[:email]
      user = User.authenticate(params[:email], params[:password])
      if (!user)
        Event.log("Bad password on #{params[:email]} and #{params[:password]}")
        flash.now[:notice] = "Invalid user/password combination"
      elsif (!user.validate_type(type))
        Event.log("Access violation  on #{user.email}, wanted #{type}")
        flash.now[:notice] = "You are not allowed to access this page or feature"
      else
        session[:user_id] = user.id
        Event.log("User #{user.email} successfully logged in with #{params[:password]}")
        redirect_to(session[:original_uri] || :index)
      end
    end
  end
  
  def logout
    uri = session[:original_uri]
    Event.log("Logout on #{session[:user_id]}")
    session[:user_id] = nil
    ##flash[:notice] = "You are logged out"
    redirect_to(uri || {:controller => :registration, :action => :index})
  end

  def index
    uri = session[:original_uri]
    session[:user_id] = nil
    redirect_to(uri || {:controller => :registration, :action => :index})
  end
  
  def change_password

    if request.post? && params[:email]
      user = User.authenticate(params[:email], params[:old_password])
      if !user
        Event.log("Change password authenticate error on #{params[:email]} and #{params[:old_password]}")
        flash[:notice] = "Invalid user/password combination"
      elsif (!valid_password(params[:new_password]))
        Event.log("Change password password format error #{params[:email]} and #{params[:new_password]}")
        ## Nothing, valid_password will set flash
      elsif (params[:new_password] != params[:confirm_new_password])
        Event.log("Change password password confirm error #{params[:new_password]} and #{params[:confirm_new_password]}")
        flash[:notice] = "New password and confirmation did not match"
      else
        user.password = params[:new_password]
        uri = session[:original_uri]
        flash[:notice] = "Password successfully changed"
        session[:original_uri] = nil
        Event.log("Change password success #{user.email} and #{params[:new_password]}")
        redirect_to(uri || {:controller => "registration", :action => "index"})
      end
    else
      user = session[:user_id] && User.find(session[:user_id])
      params[:email] = user ? user.email : ""
    end
  end
  
  def reset_password
    if request.post?
      
      ## For security let's make sure that the session user is an administrator!
      unless (session[:user_id] && User.find_by_id(session[:user_id]) && User.find_by_id(session[:user_id]).admin)
        raise("Password reset attempted by non administrator!  Logged in user id is #{session[:user_id]}")
      end
      
      user = User.find_by_email(params[:email], params[:old_password], :none)
      
      if !user
        Event.log("Reset password login error #{params[:email]} and #{params[:old_password]}")
        flash[:notice] = "Invalid user/password combination"
      elsif (!valid_password(params[:new_password]))
        Event.log("Reset password password format error #{params[:email]} and #{params[:new_password]}")
        ## Do nothing, valid_password sets the flash message
      elsif (params[:new_password] != params[:confirm_new_password])
        Event.log("Change password password confirm error #{params[:new_password]} and #{params[:confirm_new_password]}")
        flash[:notice] = "New password and confirmation did not match"
      else
        user.password = params[:new_password]
        uri = session[:original_uri]
        flash[:notice] = "Password successfully changed"
        Event.log("Reset password success #{user.email} and #{params[:new_password]}")
        session[:original_uri] = nil
        redirect_to(uri || {:controller => "admin", :action => "index"})
      end
    else
      user = session[:user_id] && User.find(session[:user_id])
      params[:email] = user ? user.email : ""
    end
  end
  
  def change_email
    if request.post?

      unless (session[:user_id] && User.find_by_id(session[:user_id]) && User.find_by_id(session[:user_id]).admin)
        raise("Email change attempted by non administrator!  Logged in user id is #{session[:user_id]}")
      end
      
      old_email = params[:old_email]
      new_email = params[:new_email]
      new_email_confirm = params[:new_email_confirm]
      user = User.find_by_email(old_email)

      if !user
        Event.log("Change email failed due to unrecognized email #{old_email}")
        #flash[:notice] = "Cannot find this email address -- do you want to create a new user instead?"
        flash[:notice] = params.to_s
      elsif new_email != new_email_confirm
        flash[:notice] = "Email addreses do not match.  Please try again."
        params[:new_email] = ""
        params[:new_email_confirm] = ""
      elsif User.find_by_email(new_email)
        Event.log("Tried to change email to existing: current is #{old_email}, requested is #{new_email}")
        flash[:notice] = "Sorry, there is already an user with that email in the system."
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || {:controller => "admin", :action => "index"})
      elsif !user.update_attribute(:email, new_email)
        Event.log("Strange failure in updating email attribute in change_email!")
        flash[:notice] = "Sorry, update failed.  Call for help!"
      else
        Event.log("Email changed on #{user.id} from #{old_email} to #{new_email}")
        flash[:notice] = "Email update successful"
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || {:controller => "registration", :action => "index"})
      end
    end
  end

  

  
  
  def new_password
    if request.post?
      email = params[:email]
      if (!User.validate_email(email))
        flash[:notice] = "Invalid email address;  please try again"
        params[:email] = ""
        params[:confirm_email] = ""
      elsif (params[:email] != params[:confirm_email])
        Event.log("New password confirm mismatch: #{params[:email]} #{params[:confirm_email]}")
        flash[:notice] = "Email does not match confirmation;  please try again"
        params[:confirm_email] = ""
      else
        user = User.try_by_email(email)
        
        if (user)
          if (User.reset_and_notify(email))
            flash[:notice] = "Your password has been reset;  new password sent to #{email}"
            Event.log("New password email succeeded: #{email}")
            uri = session[:original_uri]
            session[:original_uri] = nil
            redirect_to(uri || {:controller => "registration", :action => "index"})
          else
            flash[:notice] = "Password reset failed!"
          end
        else
          if (User.create_and_notify(email))
            flash[:notice] = "An account has been created;  the password has been sent to #{email}"
            Event.log("New account email succeeded: #{email}")
            uri = session[:original_uri]
            session[:original_uri] = nil
            redirect_to(uri || {:controller => "registration", :action => "index"})
          else
            flash[:notice] = "Account creation failed!"
          end
        end
      end
    else
      user = session[:user_id] && User.find(session[:user_id])
      params[:email] = user ? user.email : ""
      params[:confirm_email] = ""
    end
  end
  
  #=======================================================
  
  private
  
  def valid_password(p)
    unless (p && p.length >= 6)
      flash[:notice] = "Invalid password -- must be at least 6 characters"
      false
    else
      true
    end
  end
  
  
end

