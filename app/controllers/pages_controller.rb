class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :survey, :contact_form, :intel_form, :intel_new_attendee, :intel_create_attendee, :intel_subscription, :intel_thank_you]

  def home
  end

  def sandbox
  end

  def billing
    @user = User.find(params[:user_id])
    @trainings = Training.joins(sessions: :session_trainers).where(sessions: {session_trainers: {user_id: @user.id}}).uniq
  end

  def contact_form
    unless params[:email_2].present? || params[:email].empty?
      contact = IncomingContact.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message], 'Training' => params[:training], 'Date' => DateTime.now.strftime('%Y-%m-%d'))
      IncomingContactMailer.with(user: User.find(2)).new_incoming_contact(contact, User.find(2)).deliver
      # IncomingContactMailer.with(user: User.find(3)).new_incoming_contact(contact).deliver
      # IncomingContactMailer.with(user: User.find(4)).new_incoming_contact(contact).deliver
    else
      IncomingSpam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
    end
    redirect_to 'https://learn.byseven.co/thank-you.html'
  end

  def survey
    redirect_to 'https://docs.google.com/forms/d/1knOYJWvoVV7T3IVCbNqoMtTbgMiDG6zroZSPrRJm5vY/edit'
  end

  def dashboard_sevener
  end

  def airtable_import_users
    OverviewUser.all.each do |user|
      if user['Builder_id'].nil?
        new_user = User.new(firstname: user['Firstname'], lastname: user['Lastname'], email: user['Email'], access_level: 'sevener', password: 'tititoto')
        new_user.save
      end
    end
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Data imported from Airtable."
  end

  def import_airtable
    skip_authorization
    ImportAirtableJob.perform_async
    redirect_to trainings_path(page: 1)
    flash[:notice] = 'Import en cours, veuillez patienter quelques instants.'
  end

# Temp

  def intel_form
    skip_authorization
    # @client_company = ClientCompany.find(7)
    @attendee = IntelAttendee.all(filter: "{Email} = '#{params[:attendee][:email]}'").first if params[:attendee].present?
  end

  def intel_new_attendee
    skip_authorization
  end

  def intel_create_attendee
    attendee = IntelAttendee.new('Email' => params[:attendee][:email], 'Firstname' => params[:attendee][:firstname], 'Lastname' => params[:attendee][:lastname])
    attendee.save
    redirect_to intel_form_path(auth_token: params[:attendee][:auth_token], attendee: {email: attendee['Email']})
  end

  def intel_subscription
    event1_id = "recx4QlAxuGX1oKSv"
    event2_id = "recTtCEak1ME1Nd8j"
    attendee = IntelAttendee.find(params[:subscription][:attendee])
    if params[:subscription][:event1] == '1'
      if attendee['Events'].present?
        attendee['Events'] = attendee['Events'].push(event1_id).uniq
      else
        attendee['Events'] = [event1_id]
      end
    else
      if attendee['Events'].present? && attendee['Events'].include?('recx4QlAxuGX1oKSv')
        attendee['Events'].delete('recx4QlAxuGX1oKSv')
      end
    end
    if params[:subscription][:event2] == '1'
      if attendee['Events'].present?
        attendee['Events'] = attendee['Events'].push(event2_id).uniq
      else
        attendee['Events'] = [event2_id]
      end
    else
      if attendee['Events'].present? && attendee['Events'].include?('recTtCEak1ME1Nd8j')
        attendee['Events'].delete('recTtCEak1ME1Nd8j')
      end
    end
    attendee['Events'] = nil if attendee['Events'] == []
    attendee.save
    redirect_to intel_thank_you_path(auth_token: params[:subscription][:auth_token])
  end

  def intel_thank_you
  end
end


