class AddUuidToSessionTrainers < ActiveRecord::Migration[6.0]
  def change
    add_column :session_trainers, :calendar_uuid, :string
  end
end
