class Theory < ApplicationRecord
  has_many :theory_contents, dependent: :destroy
  has_many :theory_workshops, dependent: :destroy
  has_many :contents, through: :theory_contents
  has_many :workshops, through: :theory_workshops
end
