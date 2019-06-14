class Project < ApplicationRecord
  belongs_to :client_contact
  has_many :sessions, :dependent => :destroy
  has_many :project_ownerships, :dependent => :destroy
  has_many :users, through: :project_ownerships

  def start_time
    self.start_date
  end
end
