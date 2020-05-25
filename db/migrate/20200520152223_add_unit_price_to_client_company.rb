class AddUnitPriceToClientCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :client_companies, :unit_price, :float
    add_column :trainings, :unit_price, :float
    add_column :trainings, :vat, :boolean
    add_column :trainings, :gdrive_link, :string
  end
end
