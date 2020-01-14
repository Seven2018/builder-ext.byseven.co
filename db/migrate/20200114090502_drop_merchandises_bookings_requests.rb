class DropMerchandisesBookingsRequests < ActiveRecord::Migration[6.0]
  def change
    drop_table :merchandises, force: :cascade
    drop_table :bookings, force: :cascade
    drop_table :requests, force: :cascade
  end
end
