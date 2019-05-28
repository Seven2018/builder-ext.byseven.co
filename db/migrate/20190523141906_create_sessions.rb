class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string :title
      t.date :date
      t.time :start_time
      t.time :end_time
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
