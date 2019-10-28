class AddStartdateToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :start_date, :date
    add_column :bookings, :end_date, :date
    add_column :bookings, :attendee_number, :integer, default: 0
    add_column :bookings, :completed, :boolean, default: false
    add_reference :trainings, :booking, foreign_key: true
    add_column :users, :employee_id, :string
    remove_reference :bookings, :client_company, foreign_key: true
  end
end
