class ClientCompany < ApplicationRecord
  has_many :client_contacts, dependent: :destroy
end
