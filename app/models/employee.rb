class Employee < ApplicationRecord

  attr_accessor :remember_token

  validates :name,  presence: true

  VALID_GENDER_REGEX = /\AMale|Female|Other\z/
  validates :gender, presence: true, format: {with: VALID_GENDER_REGEX}

  validates :designation,  presence: true

  VALID_PHONE_REGEX = /\A\d{10}\z/
  validates :phone, presence: true, 
                  format: {with: VALID_PHONE_REGEX, message: "should have 10 digits"},
                  uniqueness: true

  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.([a-z]){2,3}+){1,2}\z/i
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }

  mount_uploader :picture, PictureUploader

  validates :personal_email, :allow_blank => true, length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false}

  validates :date_of_join,
      :date => { :after   => Proc.new {Date.parse("2009-12-31")}, :before => Proc.new{(Date.today + 31)} }
  validates :date_of_birth, 
      :allow_blank => true,
      :date => { :after   => Proc.new {100.years.ago}, :before => Proc.new{(18.years.ago)} }

  validates :address, :allow_blank => true, length: { minimum: 25, maximum: 255 }

  validates :username, presence: true
  
  # validates :validate_date_of_join, presence: true
  has_secure_password
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[\W])(?=.*[\d])[\S]{8,15}\z/
  validates :password, 
              format: { with: VALID_PASSWORD_REGEX, 
                  message: 'should contain uppercase, lowercase, numeric and special character' }, 
              length: { minimum: 8, maximum: 15 },
              allow_nil: true

  # Returns the hash digest of the given string.
  def Employee.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.koala(auth)
    access_token = auth['token']
    facebook = Koala::Facebook::API.new(access_token)
    facebook.get_object("me?fields=name,picture, email, birthday")
  end


  # Returns a random token.
  def Employee.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = Employee.new_token
    update_attribute(:remember_digest, Employee.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

end
