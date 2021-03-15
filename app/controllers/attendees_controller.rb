class AttendeesController < ApplicationController
  before_action :set_training, only: [:form]
  before_action :set_attendee, only: [:show]
  before_action :authenticate_user!, except: [:form, :new, :create, :new_kea_partners, :create_kea_partners, :template_csv, :import]
  invisible_captcha only: [:create], honeypot: :subtitle

  def index
    @client_company = ClientCompany.find(params[:client_company_id]) if params[:client_company_id].present?
    @client_company.present? ? @attendees = policy_scope(Attendee).where(client_company_id: @client_company.id) : @attendees = policy_scope(ClientCompany)
  end

  def show
    authorize @attendee
  end

  def new
    @attendee = Attendee.new
    authorize @attendee
  end

  def create
    @attendee = Attendee.new(attendee_params)
    authorize @attendee
    training = Training.find(params[:attendee][:training_id].to_i)
    form = Form.find(params[:attendee][:form_id].to_i)
    @attendee.update(client_company_id: training.client_contact.client_company.id)
    if @attendee.save
      redirect_to training_form_path(training, form, search: {email: @attendee.email}, auth_token: @attendee.client_company.auth_token)
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

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end
end
