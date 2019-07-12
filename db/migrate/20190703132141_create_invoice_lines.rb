class CreateInvoiceLines < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_lines do |t|
      t.string :description
      t.text :comments
      t.float :quantity
      t.decimal :net_amount, precision: 15, scale: 10
      t.decimal :tax_amount, precision: 15, scale: 10
      t.references :invoice_item, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
