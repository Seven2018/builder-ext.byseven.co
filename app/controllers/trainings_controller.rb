class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :destroy]

  def index
    @sessions = Session.all
    @session_trainer = SessionTrainer.new
    @form = Form.new
    # Index with 'search' option and global visibility for SEVEN Users
    if ['super admin', 'admin', 'project manager'].include?(current_user.access_level)
      if params[:search]
        @trainings = policy_scope(Training)
        @trainings = ((Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (Training.joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
      else
        @trainings = policy_scope(Training)
      end
      @bookings = Booking.all
    # # Index for HR Users, with limited visibility
    # elsif current_user.access_level == 'HR'
    #   @trainings = policy_scope(Training)
    #   @trainings = Training.joins(:client_contact).where(client_contacts: { email: current_user.email })
    #   @bookings = Booking.where(user_id: current_user.id)
    # Index for Sevener Users, with limited visibility
    else
      @trainings = policy_scope(Training).joins(sessions: :users).where("users.email LIKE ?", "#{current_user.email}")
    end
  end

  # Index when using Booklet Mode
  def index_booklet

    @trainings = Training.joins(:client_contact).where(client_contacts: { email: current_user.email })
    authorize @trainings
    @bookings = Booking.where(user_id: current_user.id)
  end

  # Index with weekly calendar view
  def index_week
    @trainings = Training.all
    @sessions = Session.all
    authorize @trainings
  end

  # Index with monthly calendar view
  def index_month
    @trainings = Training.all
    @sessions = Session.all
    authorize @trainings
  end

  def show
    authorize @training
    @training_ownership = TrainingOwnership.new
    @session = Session.new
    @users = User.all
  end

  def new
    @training = Training.new
    @training_ownership = TrainingOwnership.new
    @clients = ClientContact.all
    authorize @training
  end

  def create
    @training = Training.new(training_params)
    @training_ownership = TrainingOwnership.new(user: current_user, training: @training)
    authorize @training
    if @training.save && @training_ownership.save
      redirect_to training_path(@training)
    else
      render :new
    end
  end

  def edit
    authorize @training
  end

  def update
    authorize @training
    @training.update(training_params)
    if @training.save
      redirect_to training_path(@training)
    else
      render :edit
    end
  end

  def destroy
    @training.destroy
    authorize @training
    redirect_to trainings_path
  end

  private

  def set_training
    @training = Training.find(params[:id])
  end

  def training_params
    params.require(:training).permit(:title, :start_date, :end_date, :client_contact_id, :mode)
  end
end
