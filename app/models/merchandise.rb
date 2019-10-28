class Merchandise < ApplicationRecord
  belongs_to :theme
  has_many :requests
  has_many :bookings
  validates :name, presence: true
end
