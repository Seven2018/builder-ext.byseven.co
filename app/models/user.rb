class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :training_ownerships
  has_many :trainings, through: :training_ownerships
  has_many :session_trainers
  has_many :sessions, through: :session_trainers
  has_many :comments
  validates :access_level, inclusion: { in: ['sevener', 'training manager', 'admin', 'super admin'] }

  def fullname
    "#{firstname} #{lastname}"
  end
end
