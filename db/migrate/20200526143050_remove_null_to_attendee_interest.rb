class RemoveNullToAttendeeInterest < ActiveRecord::Migration[6.0]
  def change
    change_column_null :attendee_interests, :training_id, true
    change_column_null :attendee_interests, :session_id, true
  end
end
