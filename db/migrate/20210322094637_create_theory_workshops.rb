class CreateTheoryWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :theory_workshops do |t|
      t.references :theory, null: false, foreign_key: true
      t.references :workshop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
