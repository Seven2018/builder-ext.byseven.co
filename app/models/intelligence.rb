class Intelligence < ApplicationRecord
  has_many :contents1, class_name: 'Content', foreign_key: 'intel1_id'
  has_many :contents2, class_name: 'Content', foreign_key: 'intel2_id'
  has_many :workshops1, class_name: 'Workshop', foreign_key: 'intel1_id'
  has_many :workshops2, class_name: 'Workshop', foreign_key: 'intel2_id'
  has_many :actions
  validates :name, uniqueness: true
  validates :name, :description, presence: true, allow_blank: false
end
