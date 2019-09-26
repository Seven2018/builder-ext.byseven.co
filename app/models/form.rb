class Form < ApplicationRecord
  belongs_to :training
  has_many :session_forms, dependant: :destroy
  has_many :sessions, through: :session_forms
  validates :title, presence: true
end
