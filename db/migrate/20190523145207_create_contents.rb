class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :format
      t.integer :duration
      t.text :description
      t.string :logistic
      t.string :chapter
      t.integer :intel1_id
      t.integer :intel2_id

      t.timestamps
    end
  end
end
