class AddOpcoToClientCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :client_companies, :opco_id, :integer
  end
end
