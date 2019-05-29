class Session < ApplicationRecord
  belongs_to :project
  has_many :content_modules
end
