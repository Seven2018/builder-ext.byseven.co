class CreateInvoiceSeveners < ActiveRecord::Migration[6.0]
  def change
    create_table :invoice_seveners do |t|
      t.string :sevener_fullname
      t.timestamps
    end
  end
end
