class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :update_survey, :destroy, :copy]

  def index
    @sessions = Session.all
    # @session_trainer = SessionTrainer.new
    @form = Form.new
    # Index with 'search' option and global visibility for SEVEN Users
    if ['super admin', 'admin', 'project manager'].include?(current_user.access_level)
      if params[:search]
        if params[:search][:user]
          @trainings = policy_scope(Training)
          @trainings = ((Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).where("lower(trainings.title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
          @user = User.find(params[:search][:user])
        else
          @trainings = policy_scope(Training)
          @trainings = ((Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
        end
      elsif params[:user]
        @trainings = policy_scope(Training)
        @trainings = Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:user]}))
        @user = User.find(params[:user])
      else
        @trainings = policy_scope(Training)
      end
    # Index for Sevener Users, with limited visibility
    else
      @trainings = policy_scope(Training).joins(sessions: :users).where("users.email LIKE ?", "#{current_user.email}")
    end
  end

  def index_completed
    if ['super admin', 'admin', 'project manager'].include?(current_user.access_level)
      if params[:search]
        if params[:search][:user]
          @trainings = ((Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).where("lower(trainings.title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
          @user = User.find(params[:search][:user])
        else
          @trainings = ((Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
        end
      elsif params[:user]
        @trainings = Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:user]}))
        @user = User.find(params[:user])
      else
        @trainings = Training.all
      end
    # Index for Sevener Users, with limited visibility
    else
      @trainings = Training.joins(sessions: :users).where("users.email LIKE ?", "#{current_user.email}")
    end
    authorize @trainings
    render partial: "index_completed"
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
    authorize @training
    @training.refid = "#{Time.current.strftime('%y')}-#{(Training.last.refid[-4..-1].to_i + 1).to_s.rjust(4, '0')}"
    @training.satisfaction_survey = 'shorturl.at/gqwCZ'
    # @training.title = ClientContact.find(params[:training][:client_contact_id]).client_company.name + ' - ' + params[:training][:title]
    if @training.save
      Session.new(title: 'Session 1', date: @training.created_at, duration: 0, training_id: @training.id)
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

  def copy
    authorize @training
    @client_contact = ClientContact.find(params[:copy][:client_contact_id])
    @new_training = Training.new(@training.attributes.except("id", "created_at", "updated_at", "client_contact_id"))
    @new_training.title = params[:copy][:rename] if params[:copy][:rename].present?
    @new_training.refid = "#{Time.current.strftime('%y')}-#{(Training.last.refid[-4..-1].to_i + 1).to_s.rjust(4, '0')}"
    @new_training.client_contact_id = @client_contact.id
    if @new_training.save
      @training.sessions.each do |session|
        new_session = Session.create(session.attributes.except("id", "created_at", "updated_at", "training_id", "address", "room"))
        new_session.update(training_id: @new_training.id)
        session.workshops.each do |workshop|
          new_workshop = Workshop.create(workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
          new_workshop.update(session_id: new_session.id)
          workshop.workshop_modules.each do |mod|
            new_mod = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id", "user_id"))
            new_mod.update(workshop_id: new_workshop.id)
          end
        end
      end
      redirect_to training_path(@new_training)
    else
      raise
    end
  end

  private

  def set_training
    @training = Training.find(params[:id])
  end

  def training_params
    params.require(:training).permit(:title, :client_contact_id, :mode, :satisfaction_survey, :unit_price, :vat)
  end
end
