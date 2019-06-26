class Workshop < ApplicationRecord
  belongs_to :session
  belongs_to :theme
  acts_as_list scope: :session
end
