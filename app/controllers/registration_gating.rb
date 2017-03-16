############################################################################################
#  This is the logic for allowing registration and payment (used to light up or shut down
#  buttons in the index view, and the new and pay methods should also check this.  Logic is:
#    -- the variables FORCE_REGISTRATION_CLOSED  and FORCE_PAYMENT_CLOSED are set manually
#    -- if either is true, registration or payment is impossible
#    -- if the variables are false, the controller checks whether current date < registration date.
#            if it is (not time yet), the session email is checked against an early test list
#    -- this is communicated only by the methods can_register  and can_pay
#
#    -- for self-evals we don't want that to turn on right in January, so we have ALLOW_EVALS
#       which is set manually and communicated only by the method allow_evals

module RegistrationGating

  FORCE_REGISTRATION_CLOSED = false
  FORCE_PAYMENT_CLOSED = false
  ALLOW_SELF_EVALS = true
  SUPPRESS_DORM_ASSIGNMENT= true

  EARLY_INVITEES = %w{
      jessicacroysdale@yahoo.com
      genniewinkler@mac.com
      hanks@pobox.com 
      ivoryharp1@gmail.com
      suecdc@msn.com
}

 # EARLY_INVITEES = ["hanks@pobox.com"]

  def self.early_invitees
    EARLY_INVITEES
  end

  #  Controls messaging on the index page banner, also used do define can_register and can_pay
  #   Premature => prior to open date, display banner and allow user/password change but nothing else
  #   Open => allow everything
  #   Closed => disable new registrations and edit registration, but allow everything else

  def registration_system_status
    return :closed if FORCE_REGISTRATION_CLOSED
    return :open if Time.now.in_time_zone("Pacific Time (US & Canada)") > RegDates.registration_opens
    return :premature
  end

  def session_email
    user = session[:user_id] && User.find(session[:user_id])
    return user ? user.email : nil
  end

  def can_register
    return false if registration_system_status == :closed
    return true if registration_system_status == :open
    return session_email && EARLY_INVITEES.include?(session_email.downcase)
  end

  def can_pay
    return !FORCE_PAYMENT_CLOSED
  end

  def allow_self_evals
    ALLOW_SELF_EVALS
  end

  def suppress_dorm_assignment
    SUPPRESS_DORM_ASSIGNMENT
  end

end

