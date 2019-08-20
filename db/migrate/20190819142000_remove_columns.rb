class RemoveColumns < ActiveRecord::Migration[6.0]
  def change
    change_table :content_modules do |t|
      t.remove :instructions, :logistics
    end
    change_table :workshop_modules do |t|
      t.remove :instructions, :logistics
    end
  end
end
