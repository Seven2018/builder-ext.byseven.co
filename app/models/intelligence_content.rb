class IntelligenceContent < ApplicationRecord
  belongs_to :intelligence
  belongs_to :content
  accepts_nested_attributes_for :intelligence
end
