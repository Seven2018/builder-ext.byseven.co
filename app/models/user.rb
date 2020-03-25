class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :training_ownerships, dependent: :destroy
  has_many :trainings, through: :training_ownerships
  has_many :session_trainers, dependent: :destroy
  has_many :sessions, through: :session_trainers
  has_many :workshop_modules
  has_many :comments
  belongs_to :client_company, optional: true
  validates :access_level, inclusion: { in: ['sevener', 'training manager', 'admin', 'super admin'] }
  require 'uri'
  require 'net/http'

  def fullname
    "#{firstname} #{lastname}"
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    # unless user
    #     user = User.create(name: data['name'],
    #        email: data['email'],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
  end
end
