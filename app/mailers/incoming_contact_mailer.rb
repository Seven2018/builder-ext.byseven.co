class IncomingContactMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def new_incoming_contact(contact, user)
    @user = user
    @contact = contact
    @url = 'https://airtable.com/tbl207Sgp1Ry0Uf0W/viw3aQvcR9IwWiOYd?blocks=hide'
    mail(to: @user.email, subject: 'Nouvelle demande entrante !')
  end
end
