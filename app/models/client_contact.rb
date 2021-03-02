class ClientContact < ApplicationRecord
  belongs_to :client_company
  has_many :trainings
  validates :name, :email, presence: true
  validates_uniqueness_of :email
end
