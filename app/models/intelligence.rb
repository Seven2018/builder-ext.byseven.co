class Intelligence < ApplicationRecord
  has_many :intelligence_contents, :dependent => :destroy
  has_many :contents, through: :intelligence_contents
  validates :name, uniqueness: true
  validates :name, :description, presence: true, allow_blank: false
end
