class TrainerNotificationMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def new_trainer_notification(training, user)
    @training = training
    @sessions = training.sessions.select{|x| x.users.include?(user)}
    @user = user
    mail(to: 'brice.chapuis@byseven.co', subject: "#{@training.client_company.name} - #{@training.title} : Récapitulatif intervention")
  end

  def edit_trainer_notification(training, user)
    @training = training
    @sessions = training.sessions.select{|x| x.users.include?(user)}
    @user = user
    mail(to: 'brice.chapuis@byseven.co', subject: "#{@training.client_company.name} - #{@training.title} : Récapitulatif intervention (Mise à jour du #{Date.today.strftime('%d/%m/%Y')})")
  end
end
