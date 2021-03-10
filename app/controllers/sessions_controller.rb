class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy, :viewer, :copy_form, :copy, :copy_content, :presence_sheet]

  # Shows an InvoiceItem in html or pdf version
  def show
    authorize @session
    @session_trainer = SessionTrainer.new
    @comment = Comment.new
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
      UpdateAirtableJob.perform_async(@training)
      redirect_to training_path(@training)
    end
  end

  def edit
    @training = Training.find(params[:training_id])
    authorize @session
  end

  def update
    authorize @session
    prev_date = @session.date
    prev_start = @session.start_time
    prev_end = @session.end_time
    @session.update(session_params)
    if prev_date != @session.date || prev_start != @session.start_time || prev_end != @session.end_time
      @session.session_trainers.each do |session_trainer|
        if session_trainer.calendar_uuid.present?
          @session.training.gdrive_link.nil? ? @session.training.update(gdrive_link: session_trainer.user_id.to_s + ':' + session_trainer.calendar_uuid + ',') : @session.training.update(gdrive_link: @session.training.gdrive_link + session_trainer.user_id.to_s + ':' + session_trainer.calendar_uuid + ',')
          session_trainer.update(calendar_uuid: nil)
        end
      end
    end


    if @session.save && (params[:session][:date].present?)
      # UpdateAirtableJob.perform_async(@session.training, true)
      redirect_to training_path(@session.training, page: 1, change: true)
    end
  end

  def destroy
    @training = Training.find(params[:training_id])
    authorize @session
    @session.destroy
    UpdateAirtableJob.perform_async(@training, true)
    redirect_to training_path(@training)
  end

  # Shows a Session in "viewer mode"
  def viewer
    authorize @session
  end

  def copy_form
    authorize @session
  end

  def copy
    authorize @session
    new_sessions = []
    if params[:button] == 'copy'
      training = Training.find(params[:copy][:training_id])
      for i in 1..params[:copy][:amount].to_i
        new_session = Session.new(@session.attributes.except("id", "created_at", "updated_at", "training_id", "address", "room"))
        training.sessions.empty? ? (new_session&.date = Date.today) : (new_session&.date = @session&.date)
        new_session.training_id = training.id
        new_session.address = ''
        new_session.room = ''
        new_session.training_id = training.id
        new_session.save
        new_sessions << new_session
      end
    else
      training = Training.find(params[:training_id])
      for i in 1..params[:copy][:amount].to_i
        new_session = Session.new(@session.attributes.except("id", "created_at", "updated_at"))
        new_session&.date = @session&.date
        new_session.save
        new_sessions << new_session
      end
    end
    new_sessions.each do |new_session|
      @session.workshops.each do |workshop|
        new_workshop = Workshop.create(workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
        new_workshop.update(session_id: new_session.id, position: workshop.position)
        workshop.workshop_modules.each do |mod|
          new_mod = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id", "user_id"))
          new_mod.update(workshop_id: new_workshop.id, position: mod.position)
        end
      end
    end
    redirect_to training_path(training)
  end

  def copy_content(source, target)
    authorize @session
    target_session = Session.find(params[:copy][:session_id])
    workshop_count = target_session.workshops.count
    @session.workshops.each do |workshop|
      new_workshop = Workshop.create(workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
      new_workshop.update(session_id: target_session.id, position: workshop_count + workshop.position)
      workshop.workshop_modules.each do |mod|
        new_mod = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id", "user_id"))
        new_mod.update(workshop_id: new_workshop.id, position: mod.position)
      end
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
    params.require(:session).permit(:title, :date, :start_time, :end_time, :training_id, :duration, :lunch_duration, :attendee_number, :description, :teaser, :image, :address, :room, { user_ids: [] }, session_trainers_attributes: [:id, :session_id, :user_id])
  end
end
