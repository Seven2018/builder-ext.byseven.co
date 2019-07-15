class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 15, scale: 10
      t.integer :tax
      t.string :product_type

      t.timestamps
    end
  end
end
