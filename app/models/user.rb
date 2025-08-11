class User < ApplicationRecord
  has_secure_password
  has_many :teams, dependent: :destroy
  
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  
  def active_team
    teams.active.first
  end
  
  def current_team
    teams.order(created_at: :desc).first
  end
  
  def create_team(name)
    teams.create(name: name, total_cost: 0)
  end
  
  def has_active_team?
    teams.active.exists?
  end
  
  def has_team?
    teams.exists?
  end
end
