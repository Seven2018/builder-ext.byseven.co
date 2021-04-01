class Action < ApplicationRecord
  belongs_to :intelligence1, class_name: "Intelligence", foreign_key: 'intelligence1_id', optional: true
  belongs_to :intelligence2, class_name: "Intelligence", foreign_key: 'intelligence2_id', optional: true
  has_many :content_module, dependent: :nullify, class_name: "ContentModule", foreign_key: 'action1_id', foreign_key: 'action2_id'
  has_many :workshop_module, dependent: :nullify, class_name: "WorkshopModule", foreign_key: 'action1_id', foreign_key: 'action2_id'
  validates :name, :description, presence: true
  validates_uniqueness_of :name
  validates :description, length: {maximum: 140}
end
