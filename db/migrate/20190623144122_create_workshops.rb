class CreateWorkshops < ActiveRecord::Migration[5.2]
  def change
    create_table :workshops do |t|
      t.string :title
      t.string :format
      t.integer :duration
      t.text :description
      t.references :session, foreign_key: true
      t.string :logistic
      t.references :chapter, foreign_key: true
      t.integer :position
      t.integer :intel1_id
      t.integer :intel2_id

      t.timestamps
    end
  end
end
