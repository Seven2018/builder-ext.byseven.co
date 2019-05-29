class ClientContact < ApplicationRecord
  belongs_to :client_company
  has_many :projects
end
