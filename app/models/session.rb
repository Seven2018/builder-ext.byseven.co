class Session < ApplicationRecord
  belongs_to :training
  has_many :workshops, -> { order(position: :asc) }, dependent: :destroy
  has_many :session_trainers, dependent: :destroy
  has_many :users, through: :session_trainers
  has_many :comments, dependent: :destroy
  validate :date_included_in_training_dates?

  def start_time
    self.date
  end

  def date_included_in_training_dates?
    if date < training.start_date || date > training.end_date
      errors.add(:date, "must be included in training's dates")
    end
  end
end
