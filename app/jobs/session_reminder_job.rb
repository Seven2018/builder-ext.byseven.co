class SessionReminderJob < ApplicationJob
  include SuckerPunch::Job

  def perform
    Session.where(date: Date.today + 2.days).each do |session|
      session.users.each do |user|
        TrainerNotificationMailer.with(user: user).trainer_session_reminder(session, user).deliver
      end
    end
  end
end
