class SessionTrainer < ApplicationRecord
  belongs_to :user
  belongs_to :session
  validates_uniqueness_of :session_id, scope: :user_id
end
