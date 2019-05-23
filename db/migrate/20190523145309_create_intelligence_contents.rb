class CreateIntelligenceContents < ActiveRecord::Migration[5.2]
  def change
    create_table :intelligence_contents do |t|
      t.references :intelligence, foreign_key: true
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
