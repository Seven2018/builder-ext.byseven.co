class Theory < ApplicationRecord
  has_many :theory_contents, dependent: :destroy
  has_many :contents, through: :theory_contents
end
