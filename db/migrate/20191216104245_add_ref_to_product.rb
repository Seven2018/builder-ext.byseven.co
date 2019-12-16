class AddRefToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :reference, :string
    add_column :client_companies, :reference, :string
    add_column :invoice_items, :dunning_date, :date
  end
end
