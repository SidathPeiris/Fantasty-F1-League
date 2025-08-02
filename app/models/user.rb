class User < ApplicationRecord
  has_secure_password
  
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
end
