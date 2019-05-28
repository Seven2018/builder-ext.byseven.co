class CreateClientContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :client_contacts do |t|
      t.string :name
      t.string :email
      t.string :title
      t.text :role_description
      t.references :client_company, foreign_key: true

      t.timestamps
    end
  end
end
