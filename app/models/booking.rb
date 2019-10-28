class Booking < ApplicationRecord
  belongs_to :merchandise
  belongs_to :user
end
