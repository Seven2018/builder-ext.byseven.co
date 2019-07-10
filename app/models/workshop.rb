class Workshop < ApplicationRecord
  belongs_to :session
  belongs_to :theme, optional: true
  has_many :workshop_modules, dependent: :destroy
  acts_as_list scope: :session
end
