require 'digest/sha1'

class User < ActiveRecord::Base
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  has_many :registrations

  def has_current_registration
    most_recent_registration && most_recent_registration.year == Year.this_year
  end

  def has_previous_registration
    most_recent_registration
  end
  
  def current_registration
    r = most_recent_registration
    return nil if r.nil?
    return nil unless r.year == Year.this_year
    return r
  end

  def most_recent_registration
    sreg = registrations.to_a.sort{|r1, r2| r1.year <=> r2.year}.reverse
    sreg.empty? ? nil : sreg.first
  end
    
  def validate_email
    emailRE= /[\w._%-]+@[\w.-]+.[a-zA-Z]{2,4}/
    email && email =~ emailRE
  end
  
  def validate_password
    hashed_password || (password && password.length >= 6)
  end

  def validate
    errors.add_to_base("Password must be at least 6 characters") unless self.validate_password
    errors.add_to_base("Invalid email address") unless self.validate_email
  end

  ###  Password getter and setter
  
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
    self.save
  end

  #########################
  
  def first_name
    most_recent_registration ? most_recent_registration.first_name : nil
  end
  
  def last_name
    most_recent_registration ? most_recent_registration.last_name : nil
  end

  def display_name
    f = first_name
    l = last_name
    return "#{f} #{l}" if f && l
    return email
  end
  
  ############################################################

  def board?
    board
  end	
  
  def staff?
    staff
  end

  def self.validate_email(email)
    emailRE= /[\w._%-]+@[\w.-]+.[a-zA-Z]{2,4}/
    email && email =~ emailRE
  end
  
  # Return the user or nil if it's not there
  def self.try_by_email(e)
    User.find(:first, :conditions => ["email = ?", e])	
  end
  
  def self.authenticate(email, password)
    Rails.logger.error("Authenticating #{email} against #{password}")
    Rails.logger.error("Database #{User.connection.current_database} has #{User.all.size} users")
    password = password.strip
    user = self.find_by_email(email)
    if user
      Rails.logger.error("Found user #{user.id}")
    else
      Rails.logger.error("Found no such user")
    end
    return nil unless user
    Rails.logger.error("user hashed is #{user.hashed_password} salt is #{user.salt} encrypted is #{encrypted_password(password, user.salt)}")
    return nil unless user.hashed_password == encrypted_password(password, user.salt)
    return user
  end

  def self.reset_and_notify(email)
    user = self.try_by_email(email)
    if (user)
      new_password = self.new_random_password(email)
      user.password = new_password
      Event.log("Reset on #{email} to #{new_password}")
      RegistrationMailer.new_account(email, new_password)
    end
    user
  end
  
  def self.create_and_notify(e)
    new_user = nil
    user = self.try_by_email(e)
    unless (user)
      new_password = self.new_random_password(e)
      new_user = User.new(:email => e, :password => new_password)
      new_user.save
      Event.log("Reset on #{e} to #{new_password}")
      RegistrationMailer.new_account(e, new_password)
    end
    new_user
  end

  def self.new_random_password(email)
    if (email && email =~ /([\w._%-]+)@[\w.-]+.[a-zA-Z]{2,4}/)
      sprintf("%s-MMR-%03i", $1, rand(1000))
    else
      raise("Password change failed to match regexp: #{email}")
    end
  end

  ############################################################
  #  Access control validation -- called from controllers

  def validate_type(type)
    return true if type == :normal
    return admin if type == :admin
    return registrar if type == :registrar
    raise  "Unknown login type #{type}"
  end

  ############################################################
  private

  def self.encrypted_password(password, salt)
    string_to_hash = password + "secrect"+ salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end

