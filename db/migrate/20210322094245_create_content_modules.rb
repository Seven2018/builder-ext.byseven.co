class CreateContentModules < ActiveRecord::Migration[6.0]
  def change
    create_table :content_modules do |t|
      t.string :title
      t.text :instructions
      t.integer :duration
      t.text :logistics
      t.integer :action1_id
      t.integer :action2_id
      t.text :comments
      t.integer :position
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
