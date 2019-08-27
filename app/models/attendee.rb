class Attendee < ApplicationRecord
  belongs_to :session
  validates :firstname, :lastname, :email, presence: true
  validates_uniqueness_of :email, scope: :session_id
end
