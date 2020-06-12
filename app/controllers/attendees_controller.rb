class AttendeesController < ApplicationController
  before_action :set_training, only: [:form]
  before_action :authenticate_user!, except: [:form, :new, :create, :new_kea_partners, :create_kea_partners, :template_csv]
  invisible_captcha only: [:create], honeypot: :subtitle

  def new
    @attendee = Attendee.new
    authorize @attendee
  end

  def create
    @attendee = Attendee.new(attendee_params)
    authorize @attendee
    @attendee.update(client_company_id: Training.find(params[:attendee][:training_id].to_i).client_contact.client_company.id)
    if @attendee.save
      redirect_to training_form_path(Training.find(params[:attendee][:training_id].to_i), Form.find(params[:attendee][:form_id].to_i), search: {email: @attendee.email})
      flash[:notice] = 'Compte créé avec succès'
    else
      flash[:notice] = 'Erreur'
    end
  end

  def new_kea_partners
    skip_authorization
    @attendee = Attendee.new
    session[:my_previous_url] = URI(request.referer || '').path
  end

  def create_kea_partners
    skip_authorization
    @attendee = Attendee.new(attendee_params)
    @attendee.client_company_id = ClientCompany.find_by(name: 'KEA PARTNERS').id
    if @attendee.save
      redirect_to "#{params[:redirect]}?search[email]=#{@attendee.email}"
      flash[:notice] = 'Compte créé avec succès'
    else
      flash[:notice] = 'Erreur'
    end
  end

  # Creates new Attendees from an imported list
  def import
    @attendees = Attendee.import(params[:file])
    skip_authorization
    flash[:notice] = 'Import terminé'
    redirect_back(fallback_location: root_path)
  end

  # Exports a list of Attendees attending the current Session
  def export
    @attendees = Attendee.joins(:session_attendees).where(session_attendees: {session_id: params[:id]})
    session = Session.find(params[:id])
    skip_authorization
    respond_to do |format|
      format.html
      format.csv { send_data @attendees.to_csv, :filename => "Participants - #{session.training.title} - #{session.title} - #{session.date.strftime('%d%m%Y')}.csv"}
    end
  end

  def template_csv
    skip_authorization
    client_company_id = ClientCompany.find(params[:client_company_id]).id
    @attendees = Attendee.where(client_company_id: client_company_id)
    respond_to do |format|
      format.csv { send_data @attendees.to_csv_template, :filename => "Template import participants SEVEN.csv"}
    end
  end

  private

  def attendee_params
    params.require(:attendee).permit(:firstname, :lastname, :employee_id, :email)
  end

  def set_training
    @training = Training.find(params[:training_id])
  end
end
