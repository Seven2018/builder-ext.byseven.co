class CreateMerchandises < ActiveRecord::Migration[6.0]
  def change
    create_table :merchandises do |t|
      t.string :name
      t.string :description
      t.integer :position
      t.references :theme, foreign_key: true

      t.timestamps
    end
  end
end
