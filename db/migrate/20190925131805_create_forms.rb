class CreateForms < ActiveRecord::Migration[6.0]
  def change
    create_table :forms do |t|
      t.string :title
      t.references :training, null: false, foreign_key: true

      t.timestamps
    end
  end
end
