class Session < ApplicationRecord
  belongs_to :training
  has_many :workshops, -> { order(position: :asc) }, dependent: :destroy
  has_many :session_trainers, dependent: :destroy
  has_many :users, through: :session_trainers
  has_many :session_attendees, dependent: :destroy
  has_many :attendees, through: :session_attendees
  has_many :comments, dependent: :destroy
  has_many :session_forms, dependent: :destroy
  has_many :forms, through: :session_forms
  validates :title, :date, :duration, presence: true
  validate :date_included_in_training_dates?
  accepts_nested_attributes_for :session_trainers


  def date_included_in_training_dates?
    if !date.nil? && (date < training.start_date || date > training.end_date)
      errors.add(:date, "must be included in training's dates")
    end
  end
end
