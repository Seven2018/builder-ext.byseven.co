class AddRefToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :reference, :string
    add_column :client_companies, :reference, :string
    add_column :invoice_items, :dunning_date, :datetime
    add_column :trainings, :refid, :string
  end
end
