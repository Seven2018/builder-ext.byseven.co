class CreateTheories < ActiveRecord::Migration[6.0]
  def change
    create_table :theories do |t|
      t.string :name
      t.text :description
      t.text :references

      t.timestamps
    end
  end
end
