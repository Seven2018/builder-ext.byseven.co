class TrainerNotificationMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def new_trainer_notification(training, user)
    @training = training
    @sessions = training.sessions.select{|x| x.users.include?(user)}
    @user = user
    mail(to: [user.email, training.owners.first], subject: "#{@training.client_company.name} - #{@training.title} : Récapitulatif intervention")
  end

  def edit_trainer_notification(training, user)
    @training = training
    @sessions = training.sessions.select{|x| x.users.include?(user)}
    @user = user
    mail(to: [user.email, training.owners.first], subject: "#{@training.client_company.name} - #{@training.title} : Récapitulatif intervention (Mise à jour du #{Date.today.strftime('%d/%m/%Y')})")
  end

  def trainer_session_reminder(session, user)
    @training = session.training
    @session = session
    @user = user
    mail(to: [user.email, session.training.owners.first, 'brice.chapuis@byseven.co'], subject: "SEVEN : #{session.training.title} - Session du #{session.date.strftime('%d/%m/%Y')}")
  end
end
