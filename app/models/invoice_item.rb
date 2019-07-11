class InvoiceItem < ApplicationRecord
  belongs_to :client_company
  belongs_to :training, optional: true
  belongs_to :user, optional: true
  has_many :invoice_lines, dependent: :destroy
end
