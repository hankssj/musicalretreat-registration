# == Schema Information
# Schema version: 20111124000001
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  email           :string(255)     not null
#  admin           :boolean(1)
#  hashed_password :string(255)     not null
#  salt            :string(255)     not null
#  board           :boolean(1)
#  registrar       :boolean(1)
#  bounced_at      :time
#  created_at      :datetime
#  updated_at      :datetime
#  contact_id      :integer(4)
#

require 'digest/sha1'

class User < ActiveRecord::Base
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  has_many :registrations
  has_one :most_recent_registration,
  :class_name => 'Registration',
  :order	=> 'created_at Desc'

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
  
  def validate_email
    emailRE= /[\w._%-]+@[\w.-]+.[a-zA-Z]{2,4}/
    email && email =~ emailRE
  end
  
  def validate_password
    hashed_password || (password && password.length >= 6)
  end

  def validate
    unless self.validate_password
      errors.add_to_base("Password must be at least 6 characters")
    end
    unless self.validate_email
      errors.add_to_base("Invalid email address")
    end
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
    password = password.strip
    user = self.find_by_email(email)
    return nil unless user
    return nil unless user.hashed_password == encrypted_password(password, user.salt)
    return user
  end

  def self.reset_and_notify(email)
    user = self.try_by_email(email)
    if (user)
      new_password = self.new_random_password(email)
      user.password = new_password
      Event.log("Reset on #{email} to #{new_password}")
      RegistrationMailer.deliver_new_account(email, new_password)
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
      RegistrationMailer.deliver_new_account(e, new_password)
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
    case type
    when :normal : return true
    when :admin  : return admin
    when :registrar : return registrar
    else raise  "Unknown login type #{type}"
    end
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

