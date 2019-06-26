class Workshop < ApplicationRecord
  belongs_to :session
  belongs_to :theme
  has_many :workshop_modules
  acts_as_list scope: :session
end
