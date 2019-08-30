class CreateSessionAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :session_attendees do |t|
      t.references :session, null: false, foreign_key: true
      t.references :attendee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
