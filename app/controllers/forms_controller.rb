class FormsController < ApplicationController
  before_action :set_form, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:show]

  # Indexes Forms belonging to current Training
  def index
    @forms = policy_scope(Form)
    @training = Training.find(params[:training_id])
    @forms = @training.forms
  end

  # Renders Form, allows auto/manual creation of an Attendee, if a User is signed in or not
  def show
    authorize @form
    @training = @form.training
    user = current_user
    Attendee.create(firstname: user.firstname, lastname: user.lastname, email: user.email, client_company_id: user.client_company.id, employee_id: user.employee_id) if user_signed_in? && Attendee.where(email: user.email).empty?
  end

  # Creates a form, linking Sessions via the results of a checkbox collection
  def create
    @form = Form.new(title: params[:form][:title], training_id: params[:training_id])
    authorize @form
    array = params[:form][:session_ids].drop(1).map(&:to_i)
    if @form.save
      array.each do |ind|
        SessionForm.create(form_id: @form.id, session_id: ind)
      end
      redirect_to training_form_path(@form.training, @form)
    else
      flash[:notice] = 'Erreur'
    end
  end

  # Updates a form, linking Sessions via the results of a checkbox collection
  def update
    authorize @form
    array = params[:form][:session_ids].drop(1).map(&:to_i)
    if @form.save
      array.each do |ind|
        if SessionForm.where(form_id: @form.id, session_id: ind).empty?
          SessionForm.create(form_id: @form.id, session_id: ind)
        end
      end
      (@form.training.sessions.ids - array).each do |ind|
        unless SessionForm.where(form_id: @form.id, session_id: ind).empty?
          SessionForm.where(form_id: @form.id, session_id: ind).first.destroy
        end
      end
      redirect_to training_form_path(@form.training, @form)
    else
      flash[:notice] = 'Erreur'
    end
  end

  private

  def set_form
    @form = Form.find(params[:id])
  end

  def form_params
    params.require(:session).permit(:title, :training_id, :session_ids)
  end
end
