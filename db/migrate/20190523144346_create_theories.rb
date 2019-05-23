class CreateTheories < ActiveRecord::Migration[5.2]
  def change
    create_table :theories do |t|
      t.string :name
      t.text :description
      t.text :links
      t.text :references

      t.timestamps
    end
  end
end
