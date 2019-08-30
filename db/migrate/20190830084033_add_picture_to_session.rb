class AddPictureToSession < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :attendee_number, :integer
    add_column :sessions, :picture, :string
    remove_column :trainings, :participant_number
  end
end
