class Workshop < ApplicationRecord
  belongs_to :session
  belongs_to :theme, optional: true
  has_many :workshop_modules, dependent: :destroy
  has_many :theory_workshops, :dependent => :destroy
  has_many :theories, through: :theory_workshops
  acts_as_list scope: :session
end
