class Employee < ApplicationRecord

    validates :name,  presence: true

    VALID_GENDER_REGEX = /\AMale|Female|Other\z/
    validates :gender, presence: true, format: {with: VALID_GENDER_REGEX}

    validates :designation,  presence: true

    VALID_PHONE_REGEX = /\A\d{10}\z/
    validates :phone, presence: true, format: {with: VALID_PHONE_REGEX}, uniqueness: true

    before_save { email.downcase! }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.([a-z]){2,3}+){1,2}\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

    validates :date_of_join, presence: true

    validates :address, length: { minimum: 25, maximum: 255 }

    before_save { personal_email.downcase! }
    validates :personal_email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

    has_secure_password
    VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[\W])(?=.*[\d])[\S]{8,15}\z/
    validates :password, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true

    # Returns the hash digest of the given string.
    def Employee.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
