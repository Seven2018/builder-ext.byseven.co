class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :survey, :kea_partners_c, :kea_partners_m, :kea_partners_d, :kea_partners_thanks]

  def home
  end

  def overlord
  end

  def contact_form
    unless params[:email_2].present?
      contact = IncomingContact.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
      IncomingContactMailer.with(user: User.find(2)).new_incoming_contact(contact).deliver
    else
      IncomingSpam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
    end
    redirect_to 'https://learn.byseven.co/thank-you.html'
  end

  def contact_form_seven_x_bam
    unless params[:email_2].present?
      contact = IncomingContactBam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message], 'Choice' => params[:choice])
      IncomingContactMailer.with(user: User.find(2)).new_incoming_contact(contact).deliver
    else
      IncomingSpam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
    end
    redirect_to 'https://learn.byseven.co/thank-you.html'
  end

  def kea_partners_c
    session[:my_previous_url] = kea_partners_c_path
  end

  def kea_partners_m
    session[:my_previous_url] = kea_partners_m_path
  end

  def kea_partners_d
    session[:my_previous_url] = kea_partners_d_path
  end

  def kea_partners_thanks
  end

  def survey
    redirect_to 'https://docs.google.com/forms/d/1knOYJWvoVV7T3IVCbNqoMtTbgMiDG6zroZSPrRJm5vY/edit'
  end

  def dashboard_sevener
  end

  def numbers_activity
    if params[:numbers_activity].present?
      @starts_at = params[:numbers_activity][:starts_at]
      @ends_at = params[:numbers_activity][:ends_at]
      @trainings = Training.numbers_scope(@starts_at, @ends_at)
    else
      @starts_at = Date.today.beginning_of_year
      @ends_at = Date.today
      @trainings = Training.numbers_scope
    end
    respond_to do |format|
      format.html
      format.csv { send_data Training.where(id: @trainings.map(&:id)).numbers_activity_csv(params[:starts], params[:ends]), filename: "Numbers Activity #{params[:starts].split('-').join()} - #{params[:ends].split('-').join()}" }
    end
  end

  def numbers_sales
    if params[:numbers_sales].present?
      @starts_at = params[:numbers_sales][:starts_at]
      @ends_at = params[:numbers_sales][:ends_at]
      @invoices = InvoiceItem.numbers_scope(@starts_at, @ends_at)
    else
      @starts_at = Date.today.beginning_of_year
      @ends_at = Date.today
      @invoices = InvoiceItem.numbers_scope(@starts_at, @ends_at)
    end
  end
end


