class CreateWorkshopModules < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_modules do |t|
      t.string :title
      t.text :instructions
      t.integer :duration
      t.text :logistics
      t.integer :action1_id
      t.integer :action2_id
      t.text :comments
      t.integer :position
      t.references :user, foreign_key: true
      t.references :workshop, foreign_key: true

      t.timestamps
    end
  end
end
