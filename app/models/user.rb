class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :project_ownerships
  has_many :projects, through: :project_ownerships
  has_many :session_trainers
  has_many :sessions, through: :session_trainers
  validates :access_level, inclusion: { in: ['sevener', 'project manager', 'admin', 'super admin'] }
end
