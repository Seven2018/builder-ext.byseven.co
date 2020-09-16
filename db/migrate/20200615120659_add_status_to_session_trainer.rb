class AddStatusToSessionTrainer < ActiveRecord::Migration[6.0]
  def change
    add_column :session_trainers, :unit_price, :float
    add_column :session_trainers, :status, :string
    add_reference :session_trainers, :invoice_item, foreign_key: true
  end
end
