class InvoiceLine < ApplicationRecord
  belongs_to :invoice_item
  belongs_to :product, optional: true
end
