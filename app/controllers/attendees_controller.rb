class AttendeesController < ApplicationController
  before_action :set_training, only: [:form]
  before_action :authenticate_user!, except: [:form, :new, :create]
  invisible_captcha only: [:create], honeypot: :subtitle

  def form
    @attendee = Attendee.new
    authorize @attendee
    @sessions = @training.sessions
    if params[:search] && params[:search][:email]
      @attendee = Attendee.find_by(email: params[:search][:email])
    elsif params[:attendee]
      @attendee = Attendee.find(params[:attendee].to_i)
    end
  end

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

  def import
    @attendees = Attendee.import(params[:file])
    skip_authorization
    flash[:notice] = 'Import terminé'
    redirect_back(fallback_location: root_path)
  end

  def export
    @attendees = Attendee.joins(:session_attendees).where(session_attendees: {session_id: params[:id]})
    skip_authorization
    respond_to do |format|
      format.html
      format.csv { send_data @attendees.to_csv}
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
