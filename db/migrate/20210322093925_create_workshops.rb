class CreateWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :workshops do |t|
      t.string :title
      t.integer :duration
      t.text :description
      t.references :session, foreign_key: true
      t.references :theme, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
