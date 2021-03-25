class Session < ApplicationRecord
  belongs_to :training
  has_many :workshops, -> { order(position: :asc) }, dependent: :destroy
  has_many :session_trainers, dependent: :destroy
  has_many :users, through: :session_trainers
  validates :title, :duration, presence: true
  accepts_nested_attributes_for :session_trainers
  default_scope { order(:date, :start_time) }

  def self.send_reminders
    Session.where(date: Date.today + 2.days).each do |session|
      session.users.each do |user|
        TrainerNotificationMailer.with(user: user).trainer_session_reminder(session, user).deliver_now
      end
    end
  end
end
