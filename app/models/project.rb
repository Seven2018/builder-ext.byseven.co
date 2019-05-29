class Project < ApplicationRecord
  belongs_to :client_contact
  has_many :sessions
  has_many :project_ownerships
  has_many :users, through: :project_ownerships
end
