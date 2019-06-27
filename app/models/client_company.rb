class ClientCompany < ApplicationRecord
  has_many :client_contacts, dependent: :destroy
  validates :client_company_type, inclusion: { in: %w(Entreprise Ecole) }
end
