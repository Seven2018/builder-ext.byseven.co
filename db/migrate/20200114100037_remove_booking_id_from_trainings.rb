class RemoveBookingIdFromTrainings < ActiveRecord::Migration[6.0]
  def change
    remove_reference :trainings, :booking
  end
end
