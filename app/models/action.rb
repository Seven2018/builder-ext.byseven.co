class Action < ApplicationRecord
  belongs_to :intelligence
  has_many :content_module, dependent: :nullify, class_name: "ContentModule", foreign_key: 'action1_id', foreign_key: 'action2_id'
  has_many :workshop_module, dependent: :nullify, class_name: "WorkshopModule", foreign_key: 'action1_id', foreign_key: 'action2_id'
  validates :description, length: {maximum: 140}
end
