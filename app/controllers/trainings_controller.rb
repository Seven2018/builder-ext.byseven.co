class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :destroy, :copy, :sevener_billing, :invoice_form, :trainer_notification_email]

  def index
    # Index with 'search' option and global visibility for SEVEN Users
    n = params[:page].to_i
    @trainings = policy_scope(Training)
    if params[:search]
      trainings = Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%")
      trainings_empty = trainings.reject{|x| x.end_time.present?}
      trainings_with_date = trainings.reject{|y| !y.end_time.present?}.sort_by{|z| z.end_time}.reverse
      @trainings = trainings_empty + trainings_with_date
    end
  end

  def index_upcoming
    if params[:search]
      @trainings = Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%")
    else
      @trainings = Training.all.select{|x| x.end_time.present? && x.end_time >= Date.today}.sort_by{|y| y.next_session}
    end
    skip_authorization
    render partial: "index_upcoming"
  end

  def index_completed
    if params[:search]
      @trainings = Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%")
    else
      @trainings = Training.all.select{|x| x.end_time.present? && x.end_time < Date.today}.sort_by{|y| y.end_time}.reverse
    end
    skip_authorization
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
    unless params[:page].present?
      redirect_to training_path(@training, page: 1)
    end
  end

  def show_session_content
    skip_authorization
    @session = Session.find(params[:session_id])
    render partial: "show_session_content"
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
    begin
      @training.refid = "#{Time.current.strftime('%y')}-#{(Training.last.refid[-4..-1].to_i + 1).to_s.rjust(4, '0')}"
    rescue
    end
    @training.satisfaction_survey = 'https://learn.byseven.co/survey'
    if @training.save
      Session.create(title: 'Session 1', date: @training.created_at, duration: 0, training_id: @training.id)
      redirect_to training_path(@training)
    else
      render :new
    end
  end

  def edit
    authorize @training
    @training.export_airtable
  end

  def update
    authorize @training
    @training.update(training_params)
    @training.save
    # UpdateAirtableJob.perform_async (@training)
    # @training.export_airtable
    redirect_to training_path(@training)
  end

  def destroy
    authorize @training
    @training.destroy
    redirect_to trainings_path(page: 1)
  end

  def copy
    authorize @training
    target_training = Training.find(params[:copy][:training_id])
    if target_training.present?
      @training.sessions.each do |session|
        new_session = Session.create(session.attributes.except("id", "created_at", "updated_at", "training_id", "address", "room"))
        new_session.update(training_id: target_training.id)
        session.workshops.each do |workshop|
          new_workshop = Workshop.create(workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
          new_workshop.update(session_id: new_session.id)
          workshop.workshop_modules.each do |mod|
            new_mod = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id", "user_id"))
            new_mod.update(workshop_id: new_workshop.id)
          end
          j = 1
          new_workshop.workshop_modules.order(position: :asc).each{|mod| mod.update(position: j); j += 1}
        end
        i = 1
        new_session.workshops.order(position: :asc).each{|workshop| workshop.update(position: i); i += 1}
      end
      redirect_to training_path(target_training)
    else
      raise
    end
  end

  def trainer_notification_email
    authorize @training
    if params[:status] == 'new'
      @training.trainers.each do |user|
      # if ['sevener+','sevener'].include?(user.access_level)
          TrainerNotificationMailer.with(user: user).new_trainer_notification(@training, user).deliver
      # end
      end
    elsif params[:trainers][:status] == 'edit'
      user_ids = params[:session][:user_ids][1..-1].map{|x| x.to_i}
      @training.trainers.select{|x| user_ids.include?(x.id)}.each do |user|
        # if ['sevener+','sevener'].include?(user.access_level)
            TrainerNotificationMailer.with(user: user).edit_trainer_notification(@training, user).deliver
        # end
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def trainer_reminder_email(session, user)
    skip_authorization
    # if ['sevener+','sevener'].include?(user.access_level)
      TrainerNotificationMailer.with(user: user).trainer_session_reminder(session, user).deliver
    # end
  end

  private

  def set_training
    @training = Training.find(params[:id])
  end

  def training_params
    params.require(:training).permit(:title, :client_contact_id, :mode, :satisfaction_survey, :unit_price, :vat)
  end
end
