class SessionAttendee < ApplicationRecord
  belongs_to :session
  belongs_to :attendee
  validates_uniqueness_of :session_id, scope: :attendee_id
end
