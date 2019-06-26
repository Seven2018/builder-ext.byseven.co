class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.string :name
      t.text :description
      t.references :intelligence, foreign_key: true

      t.timestamps
    end
  end
end
