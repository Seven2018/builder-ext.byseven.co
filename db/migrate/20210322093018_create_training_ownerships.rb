class CreateTrainingOwnerships < ActiveRecord::Migration[6.0]
  def change
    create_table :training_ownerships do |t|
      t.references :user, foreign_key: true
      t.references :training, foreign_key: true

      t.timestamps
    end
  end
end
