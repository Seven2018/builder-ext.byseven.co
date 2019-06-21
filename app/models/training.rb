class Training < ApplicationRecord
  belongs_to :client_contact
  has_many :sessions, :dependent => :destroy
  has_many :training_ownerships, :dependent => :destroy
  has_many :users, through: :training_ownerships

  def start_time
    self.start_date
  end
end
