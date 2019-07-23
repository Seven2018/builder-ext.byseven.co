class AddBillingContactToClientCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :client_companies, :billing_contact, :string
    add_column :client_companies, :billing_email, :string
    add_column :client_companies, :billing_address, :string
  end
end
