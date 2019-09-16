class Session < ApplicationRecord
  belongs_to :training
  has_many :workshops, -> { order(position: :asc) }, dependent: :destroy
  has_many :session_trainers, dependent: :destroy
  has_many :users, through: :session_trainers
  has_many :session_attendees
  has_many :attendees, through: :session_attendees
  has_many :comments, dependent: :destroy
  validates :date, :duration, presence: true
  validate :date_included_in_training_dates?


  def date_included_in_training_dates?
    if !date.nil? && (date < training.start_date || date > training.end_date)
      errors.add(:date, "must be included in training's dates")
    end
  end
end
