class CreateSessionTrainers < ActiveRecord::Migration[6.0]
  def change
    create_table :session_trainers do |t|
      t.string :calendar_uuid
      t.references :user, foreign_key: true
      t.references :session, foreign_key: true

      t.timestamps
    end
  end
end
