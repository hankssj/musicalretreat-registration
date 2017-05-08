class RegistrationMailer < ActionMailer::Base

  default :from => "registrar@musicalretreat.org", 
  :reply_to => "registrar@musicalretreat.org", 
  :reply_to => "online-registration@musicalretreat.org", 
  :cc => "online-registration@musicalretreat.org"

  def test(email)
    mail(:from => "online-registration@musicalretreat.org", :to => email, :subject => "New Message, just checking this peram").deliver!
  end

  # Bulk email inviting to register
  #  User.all.reject{|u| u.bounced_at || u.test || u.has_current_registration}.each{|u| invitation
  def invitation(user)
    @first_name = user.first_name
    @year = Year.this_year
    mail(:from => "online-registration@musicalretreat.org", :to => user.email, :subject=> "MMR #{Year.this_year} Registration").deliver!
    Event.log("Sent invitation email to #{user.id}")
  end

  def faculty_registration_invitation(e)
    @year = Year.this_year
    mail(:from => "online-registration@musicalretreat.org", :to => e, :subject=> "MMR #{Year.this_year} Registration").deliver!
  end

  #  This might/should replace the invitation above
  def mass_email_invitation(email, unsubscribe_id)
    @unsubscribe_id = unsubscribe_id
    #attachments.inline['facebook_icon.jpg'] = { data: File.read(Rails.root.join('app/assets/images/facebook_icon.jpg')), mime_type: 'image/jpg'}
    mail(:from => "online-registration@musicalretreat.org", :to => email, :subject=> "MMR #{Year.this_year} Registration").deliver!
    Rails.logger.info("Sent mass invitation email to #{email} with code #{unsubscribe_id}")
  end

  # Some other kind of mass mailing 
  def mass_email_generic(email, unsubscribe_id)
    @unsubscribe_id = unsubscribe_id
    subject = "Put your subject here"
    attachments.inline['givebig_2017_email_header.png'] = { data: File.read(Rails.root.join('app/assets/images/givebig_2017_email_header.png')), mime_type: 'image/png'}
    attachments.inline['mmr_email_logo.jpg'] = { data: File.read(Rails.root.join('app/assets/images/mmr_email_logo.jpg')), mime_type: 'image/jpg'}
    mail(:from => "midsummer@musicalretreat.org", :to => email, :subject=> subject).deliver!
    Rails.logger.info("Sent mass invitation email to #{email} with code #{unsubscribe_id}")
  end

  def self_eval_invitation(user)
    @first_name = user.first_name
    @year = Year.this_year
    mail(:from => "online-registration@musicalretreat.org", :to => user.email, :subject=> "MMR #{Year.this_year} Ensemble Selection and Self Evaluation").deliver!
    Event.log("Sent invitation email to #{user.id}")
  end

  def self_eval_reminder(user)
    @first_name = user.first_name
    @year = Year.this_year
    mail(:from => "online-registration@musicalretreat.org", 
         :to => user.email, 
         :subject=> "REMINDER: Fill out your MMR #{Year.this_year} Ensemble Selection and Self Evaluation").deliver!
    Event.log("Sent invitation email to #{user.id}")
  end

  def early_invitation(email)
    mail(:to => email, :subject => "Please register early and test the registration system").deliver!
  end
    
  # From the reg invitation button on admin.  This either creates or uses a password
  def invitation_with_new_password(email, password)
    @email = email
    @password = password
    mail(:to => email, :subject => "Come register for MMR #{Year.this_year}").deliver!
  end

  # After successfull form submit
  def confirm_registration(registration)
    @name = "#{registration.first_name} #{registration.last_name}"
    @cart = registration.cart
    @payment = -@cart.payment_net
    @balance = @cart.balance
    mail(:to => registration.user.email, :subject => "MMR Registration Confirmation").deliver!
    Event.log("Sent registration confirmation email to #{registration.user.email}")
  end

  def registration_summary(registration)
    @registration = registration
    @name = "#{registration.first_name} #{registration.last_name}"
    # @cart = registration.cart
    # @payment = -@cart.payment_net
    # @balance = @cart.balance
    @balance = @registration.balance
    mail(:to => registration.user.email, :subject => "MMR Housing Assignment and Account Balance").deliver!
    Event.log("Sent registration confirmation email to #{registration.user.email}")
  end

  ## This is a one-off I hope -- the registration_summary mailing computed balance on the basis of 
  ## aRegistration.cart.balance rather than aRegistration.balance and for reasons I haven't figured out 
  ## yet, there are a number of cases where the latter is 0 (and correctly 0) but the former is > 0.
  ## For now just send them an apology email.  Also I corrected the code above.  
//  def registration_summary_balance_correction(registration)
//    @name = "#{registration.first_name} #{registration.last_name}"
//    mail(:to => registration.user.email, 
//         :cc => "registrar@musicalretreat.org", 
//         :subject => "MMR Account Balance CORRECTION").deliver!
//  end

  def confirm_payment(payment)
    @name = "#{payment.registration.first_name} #{payment.registration.last_name}"
    @payment = payment
    mail(:to => payment.registration.user.email, :subject => "MMR Payment Confirmation").deliver!
    Event.log("Sent payment confirmation email to #{payment.registration.user.email}")
  end

  def new_account(email, password)
    @email = email
    @password = password
    mail(:to => email, :subject => "MMR New Account or Password Reset").deliver!
    Event.log("Sent new account or password reset to #{@email} and #{@password}")
  end

  def balance_reminder(registration)
    @name = registration.display_name
    @balance = registration.balance
    mail(:to => registration.email, :subject => 'MMR Balance Due Reminber').deliver!
  end

  def eval_reminder(registration)
    @name = registration.display_name
    mail(:to => registration.email, :subject => 'MMR Ensemble Choice and Self-Evaluation Reminber').deliver!
  end

end
