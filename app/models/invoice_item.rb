class InvoiceItem < ApplicationRecord
  belongs_to :client_company
  belongs_to :training, optional: true
end
