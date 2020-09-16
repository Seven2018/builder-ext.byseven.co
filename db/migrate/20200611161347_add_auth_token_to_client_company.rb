class AddAuthTokenToClientCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :client_companies, :auth_token, :string
  end
end
