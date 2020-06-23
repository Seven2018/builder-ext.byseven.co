class IncomingContactMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def new_incoming_contact(contact)
    @user = params[:user]
    @contact = contact
    mail(to: @user.email, subject: 'Nouvelle demande entrante !')
  end
end
