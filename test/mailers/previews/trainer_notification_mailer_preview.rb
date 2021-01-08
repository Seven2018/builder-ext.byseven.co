# Preview all emails at http://localhost:3000/rails/mailers/trainer_notification_mailer
class TrainerNotificationMailerPreview < ActionMailer::Preview

  def new_trainer_notification
    TrainerNotificationMailer.with(user: User.find(2)).new_trainer_notification(Training.last, User.find(2))
  end
end
