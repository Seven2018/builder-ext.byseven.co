class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy, :viewer, :copy, :copy_here, :presence_sheet]

  # Shows an InvoiceItem in html or pdf version
  def show
    authorize @session
    @contents = Content.all
    @session_trainer = SessionTrainer.new
    @comment = Comment.new
    @themes = Theme.all
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@session.title}",
          layout: 'pdf.html.erb',
          template: 'sessions/show',
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 300,
          zoom: 1,
        )
      end
    end
  end

  def new
    @training = Training.find(params[:training_id])
    @session = Session.new
    authorize @session
  end

  def create
    @training = Training.find(params[:training_id])
    @session = Session.new(session_params)
    authorize @session
    @session.training = @training
    if @session.save
      redirect_to training_path(@training)
    end
  end

  def edit
    @training = Training.find(params[:training_id])
    authorize @session
  end

  def update
    @training = Training.find(params[:training_id])
    authorize @session
    @session.update(session_params)

    trainers_list = ''
    @session.users.each do |user|
      trainers_list += "#{user.id},"
    end

    event_to_delete = ''
    SessionTrainer.where(session_id: @session.id).each do |trainer|
      event_to_delete+=trainer.user_id.to_s+':'+trainer.calendar_uuid+',' if trainer.calendar_uuid.present?
    end
    event_to_delete = event_to_delete[0...-1]

    if @session.save
      redirect_to redirect_path(session_id: "|#{@session.id}|", list: trainers_list, to_delete: "%#{event_to_delete}%")
    else
      redirect_to training_path(@session.training)
      flash[:alert] = 'Something went wrong, please verify all parameters (ex: is the new session date included in the training period ?)'
    end
  end

  def destroy
    @training = Training.find(params[:training_id])
    authorize @session
    @session.destroy
    redirect_to training_path(@training)
  end

  # Shows a Session in "viewer mode"
  def viewer
    authorize @session
  end

  def copy
    authorize @session
    training = Training.find(params[:copy][:training_id])
    new_session = Session.new(@session.attributes.except("id", "created_at", "updated_at", "training_id", "date", "address", "room"))
    new_session.title = params[:copy][:rename] if params[:copy][:rename].present?
    new_session.date = params[:copy][:date] if params[:copy][:date].present?
    new_session.training_id = training.id
    if new_session.save
      @session.workshops.each do |workshop|
        new_workshop = Workshop.create(workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
        new_workshop.update(session_id: new_session.id)
        workshop.workshop_modules.each do |mod|
          new_mod = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id", "user_id"))
          new_mod.update(workshop_id: new_workshop.id)
        end
      end
      redirect_to training_path(training)
    else
      raise
    end
  end

  def copy_here
    authorize @session
    new_session = Session.new(@session.attributes.except("id", "created_at", "updated_at"))
    if new_session.save
      @session.workshops.each do |workshop|
        new_workshop = Workshop.create(workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
        new_workshop.update(session_id: new_session.id)
        workshop.workshop_modules.each do |mod|
          new_mod = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id", "user_id"))
          new_mod.update(workshop_id: new_workshop.id)
        end
      end
      redirect_to training_path(@session.training)
    else
      raise
    end
  end

  def presence_sheet
    authorize @session
    respond_to do |format|
      format.pdf do
        render(
          pdf: "#{@session.title}",
          layout: 'pdf.html.erb',
          template: 'sessions/presence_sheet',
          margin: { top: 110 },
          header: { spacing: 1.51, html: { template: 'sessions/header.pdf.erb' } },
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 300,
          zoom: 1,
          viewport_size: '1280x1024'
        )
      end
    end
  end

  private

  def set_session
    @session = Session.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:title, :date, :start_time, :end_time, :training_id, :duration, :attendee_number, :description, :teaser, :image, :address, :room, { user_ids: [] }, session_trainers_attributes: [:id, :session_id, :user_id])
  end
end
