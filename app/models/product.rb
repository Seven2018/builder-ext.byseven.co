class Product < ApplicationRecord
  has_many :invoice_lines
end
