class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.integer :duration
      t.text :description
      t.references :theme, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
