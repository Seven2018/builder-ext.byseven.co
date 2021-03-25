class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.string :name
      t.text :description
      t.integer :intelligence1_id
      t.integer :intelligence2_id

      t.timestamps
    end
  end
end
