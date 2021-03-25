class CreateTrainings < ActiveRecord::Migration[6.0]
  def change
    create_table :trainings do |t|
      t.string :title
      t.string :calendar_temp

      t.timestamps
    end
  end
end
