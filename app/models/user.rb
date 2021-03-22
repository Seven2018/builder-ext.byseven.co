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
  validates :firstname, :lastname, :email, presence: true
  validates_uniqueness_of :email
  validates :access_level, inclusion: { in: ['user', 'super admin'] }
  require 'uri'
  require 'net/http'

  def fullname
    "#{firstname} #{lastname}"
  end
end
