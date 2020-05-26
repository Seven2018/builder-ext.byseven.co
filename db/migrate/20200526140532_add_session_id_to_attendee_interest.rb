class AddSessionIdToAttendeeInterest < ActiveRecord::Migration[6.0]
  def change
    add_reference :attendee_interests, :session, foreign_key: true
  end
end
