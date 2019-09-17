class Action < ApplicationRecord
  belongs_to :intelligence
  validates :description, length: {maximum: 140}
end
