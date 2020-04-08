class AddTypeToTrainingOwnership < ActiveRecord::Migration[6.0]
  def change
    add_column :training_ownerships, :user_type, :string
  end
end
