class AttendeeInterest < ApplicationRecord
  belongs_to :training, optional: true
  belongs_to :session, optional: true
  belongs_to :attendee
  validates_uniqueness_of :session_id, scope: :attendee_id
end
