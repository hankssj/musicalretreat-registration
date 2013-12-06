class RegistrationMailer < ActionMailer::Base

  def confirm_registration(registration, payment, balance)
    @subject    		= 'MMR Registration Confirmation'
    @body["registration"] 	= registration
    @body["cart"] 		= registration.cart
    @body["payment"] 		= payment
    @body["balance"] 		= balance

    @recipients 		= registration.email
    @from       		= 'registrar@musicalretreat.org'
    @cc 			= 'online-registration@musicalretreat.org'
    @sent_on    		= Time.now

    Event.log("Sent registration confirm to #{registration.email}")
  end


  def balance_reminder(registration)
    @subject    		= 'MMR Balance Due Reminder'
    @body["balance"] 		= registration.balance
    @body["name"] 		= registration.display_name

    @recipients 		= registration.email
    @from       		= 'registrar@musicalretreat.org'
    @cc 			= 'online-registration@musicalretreat.org'
    @sent_on    		= Time.now

    Event.log("Sent balance reminder to #{registration.email}")
  end

  def new_account(email, password)
    @recipients 		= email
    @subject    		= 'New account or password reset from Midsummer Musical Retreat'
    @body["email"] 		= email
    @body["password"] 		= password

    @from       		= 'online-registration@musicalretreat.org'
    @cc 			= 'online-registration@musicalretreat.org'
    @sent_on    		= Time.now

    Event.log("Sent new account email to #{email}")
  end
  
  def reg_invitation_with_new_password(user, new_password)
  	@recipients = user.email
  	@subject = "Come register for MMR #{Year.this_year}"

  	@body[:first_name]       = user.first_name
	@body[:email]		 = user.email
	@body[:password]         = new_password
	@body[:year]		 = Year.this_year

  	@from = 'registrar@musicalretreat.org'
  	@cc = 'online-registration@musicalretreat.org'
  	@sent_on = Time.now

  	Event.log("Sent invitation email to #{@recipients}")
  end

  def reg_invitation_without_new_password(user)
  	@recipients = user.email
  	@subject = "Come register for MMR #{Year.this_year}"

  	@body[:first_name]       = user.first_name
	@body[:email]		 = user.email
	@body[:year]		 = Year.this_year

  	@from = 'registrar@musicalretreat.org'
  	@cc = 'online-registration@musicalretreat.org'
  	@sent_on = Time.now

  	Event.log("Sent invitation email to #{@recipients}")
  end

  
  def confirm_payment(payment)
  	@recipients = payment.registration.email
  	@subject = 'MMR Payment Confirmation'
  	@from    = 'registrar@musicalretreat.org'
  	@cc      = 'online-registration@musicalretreat.org'
  	@sent_on = Time.now
  	@body =  { :payment => payment, :year => Year.this_year }
  	Event.log("Send payment confirmation to #{@recipients}")
  end
  
end
