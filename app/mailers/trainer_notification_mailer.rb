class TrainerNotificationMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def new_trainer_notification(training, user)
    @training = training
    @sessions = training.sessions.select{|x| x.users.include?(user)}
    @user = user
    mail(to: @user.email, subject: "#{@training.client_company.name} - #{@training.title} : Récapitulatif intervention")
  end
end
