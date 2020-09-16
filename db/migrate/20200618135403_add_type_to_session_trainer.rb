class AddTypeToSessionTrainer < ActiveRecord::Migration[6.0]
  def change
    add_column :session_trainers, :type, :string
  end
end
