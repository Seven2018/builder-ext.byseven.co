class TrainingOwnership < ApplicationRecord
  belongs_to :user
  belongs_to :training
  validates_uniqueness_of :user_id, scope: :training_id
end
