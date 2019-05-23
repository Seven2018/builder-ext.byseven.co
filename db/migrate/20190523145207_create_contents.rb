class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :format
      t.integer :duration
      t.text :description
      t.string :logistic
      t.string :chapter

      t.timestamps
    end
  end
end
