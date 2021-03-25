class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.string :title
      t.date :date
      t.float :duration
      t.time :start_time
      t.time :end_time
      t.integer :attendee_number
      t.references :training, foreign_key: true
      t.string :log
      t.string :comments

      t.timestamps
    end
  end
end
