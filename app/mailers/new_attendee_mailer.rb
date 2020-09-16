class NewAttendeeMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def new_attendee(session_attendee)
    @user = params[:user]
    @attendee = session_attendee.attendee
    @session = session_attendee.session
    mail(to: @user.email, subject: 'Nouvelle participant !')
  end
end
