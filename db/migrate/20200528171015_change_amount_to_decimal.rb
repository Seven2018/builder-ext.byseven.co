class ChangeAmountToDecimal < ActiveRecord::Migration[6.0]
  def up
    change_column :invoice_items, :total_amount, :decimal, :precision => 16, :scale => 8
    change_column :invoice_items, :tax_amount, :decimal, :precision => 16, :scale => 8
    change_column :invoice_lines, :net_amount, :decimal, :precision => 16, :scale => 8
    change_column :invoice_lines, :tax_amount, :decimal, :precision => 16, :scale => 8
  end
end
