class ClientCompany < ApplicationRecord
  has_many :client_contacts, dependent: :destroy
  has_many :invoice_items
  validates :client_company_type, inclusion: { in: %w(Entreprise Ecole) }
end
