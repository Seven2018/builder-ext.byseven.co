class CreateInvoiceLines < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_lines do |t|
      t.string :description
      t.integer :quantity
      t.decimal :net_amount
      t.decimal :tax_amount
      t.references :invoice_item, foreign_key: true

      t.timestamps
    end
  end
end
