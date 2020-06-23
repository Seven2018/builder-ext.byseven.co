# Preview all emails at http://localhost:3000/rails/mailers/incoming_contact_mailer
class IncomingContactMailerPreview < ActionMailer::Preview
  def new_incoming_contact
    IncomingContactMailer.with(user: User.first).new_incoming_contact(IncomingContact.all.first)
  end
end
