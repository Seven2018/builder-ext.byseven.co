class Intelligence < ApplicationRecord
  # has_many :intelligence_contents, :dependent => :destroy
  has_many :contents1, class_name: 'Content', foreign_key: 'intel1_id'
  has_many :contents2, class_name: 'Content', foreign_key: 'intel2_id'
  has_many :content_modules1, class_name: 'ContentModule', foreign_key: 'intel1_id'
  has_many :content_modules2, class_name: 'ContentModule', foreign_key: 'intel2_id'
  validates :name, uniqueness: true
  validates :name, :description, presence: true, allow_blank: false
end
