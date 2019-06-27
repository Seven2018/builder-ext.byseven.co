class CreateClientCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :client_companies do |t|
      t.string :name
      t.string :address
      t.string :client_company_type
      t.text :description
      t.string :logo

      t.timestamps
    end
  end
end
