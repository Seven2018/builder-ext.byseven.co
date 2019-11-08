class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client_company, null: false, foreign_key: true
      t.references :merchandise, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :users, :client_company, index: true, foreign_key: true
  end
end
