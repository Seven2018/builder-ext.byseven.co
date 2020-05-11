class CreateAttendeeInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :attendee_interests do |t|
      t.references :training, null: false, foreign_key: true
      t.references :attendee, null: false, foreign_key: true
      t.timestamps
    end
  end
end
