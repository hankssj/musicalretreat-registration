# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_mmr_session_id'
  
    def login_email
    	(session[:user_id] && User.find_by_id(session[:user_id])) ? User.find_by_id(session[:user_id]).email : ""
    end
    
    private
  
    def authorize_admin
    	authorize_helper(:admin)
    end

    def authorize_registrar
	authorize_helper(:registrar)
    end
    
    def authorize
    	authorize_helper(:normal)
    end
    
    def authorize_helper(type = :normal)
	u = User.find_by_id(session[:user_id])
	unless (u && u.validate_type(type))
        	session[:original_uri] = request.request_uri
     	 	session[:login_type] = type
	        redirect_to(:controller => "login", :action => "login")
        end
    end

    def admin_session?
	return false unless session[:user_id]
	u = User.find_by_id(session[:user_id])
	return u && u.admin
    end	

    def session_email
	return nil unless session[:user_id]
	u = User.find_by_id(session[:user_id])
	return nil unless u
	return u.email
    end	

end
