class CreateContentModules < ActiveRecord::Migration[5.2]
  def change
    create_table :content_modules do |t|
      t.string :title
      t.string :format
      t.integer :duration
      t.text :description
      t.references :user, foreign_key: true
      t.string :logistic
      t.string :chapter

      t.timestamps
    end
  end
end
