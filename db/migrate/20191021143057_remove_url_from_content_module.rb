class RemoveUrlFromContentModule < ActiveRecord::Migration[6.0]
  def change
    remove_column :content_modules, :url1
    remove_column :content_modules, :url2
    remove_column :content_modules, :image1
    remove_column :content_modules, :image2
    remove_column :workshop_modules, :url1
    remove_column :workshop_modules, :url2
    remove_column :workshop_modules, :image1
    remove_column :workshop_modules, :image2
    add_column :client_contacts, :billing_contact, :string
    add_column :client_contacts, :billing_email, :string
    add_column :client_contacts, :billing_address, :string
    add_column :client_contacts, :billing_zipcode, :string
    add_column :client_contacts, :billing_city, :string
    remove_column :client_companies, :billing_contact
    remove_column :client_companies, :billing_email
    remove_column :client_companies, :billing_address
    add_column :client_companies, :zipcode, :string
    add_column :client_companies, :city, :string
    add_column :invoice_lines, :position, :integer
    remove_reference :actions, :intelligence, index: true, foreign_key: true
    add_column :actions, :intelligence1_id, :integer
    add_column :actions, :intelligence2_id, :integer
  end
end
