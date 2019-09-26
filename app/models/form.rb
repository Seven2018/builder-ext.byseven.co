class Form < ApplicationRecord
  belongs_to :training
  has_many :session_forms, dependent: :destroy
  has_many :sessions, through: :session_forms
  validates :title, presence: true
  accepts_nested_attributes_for :session_forms
end
