class TrainingOwnership < ApplicationRecord
  belongs_to :user
  belongs_to :training
end
