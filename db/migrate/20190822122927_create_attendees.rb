class CreateAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :attendees do |t|
      t.string :firstname
      t.string :lastname
      t.string :employee_id
      t.string :email
      t.references :client_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
