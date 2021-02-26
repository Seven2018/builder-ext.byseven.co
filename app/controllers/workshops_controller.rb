class WorkshopsController < ApplicationController
  before_action :set_module, only: [:show, :edit, :update, :destroy, :move, :move_up, :move_down, :save, :viewer, :copy_form, :copy]

  def show
    authorize @workshop
    @theory_workshop = TheoryWorkshop.new
  end

  def create
    @session = Session.find(params[:session_id])
    if params[:content_id].present?
      @content = Content.find(params[:content_id])
      @workshop = Workshop.new(@content.attributes.except("id", "created_at", "updated_at"))
    else
      @workshop = Workshop.new(title: 'New workshop', duration: 0)
    end
    authorize @workshop
    @workshop.session = @session
    i = 1
    if @workshop.save
      if params[:content_id].present?
        @content.theories.each do |theory|
          TheoryWorkshop.create(theory_id: theory.id, workshop_id: @workshop.id)
        end
        @content.content_modules.order('position ASC').each do |mod|
          wmod = WorkshopModule.new(mod.attributes.except("id", "position", "created_at", "updated_at", "content_id"))
          wmod.workshop = @workshop
          wmod.position = i
          i +=1
          wmod.save
        end
      end
      respond_to do |format|
        format.html {redirect_to training_session_path(@session.training, @session)}
        format.js
      end
    else
      raise
    end
    Comment.create(object: 'Log', content: "Module #{@workshop.title} added |", user_id: current_user.id, session_id: @workshop.session.id)
  end

  def edit
    authorize @workshop
  end

  def update
    params = @workshop.attributes
    authorize @workshop
    @workshop.update(workshop_params)
    if @workshop.save
      comment = Comment.create(object: 'Log', content: "Module #{@workshop.title} updated | from #{params.except('id', 'created_at', 'updated_at', 'session_id')} to #{@workshop.attributes.except('id', 'created_at', 'updated_at', 'session_id')}",
                     user_id: current_user.id, session_id: @workshop.session.id)
      redirect_back(fallback_location: root_path)
    else
      render :edit
    end
  end

  def destroy
    Comment.create(object: 'Log', content: "Module #{@workshop.title} removed |", user_id: current_user.id, session_id: @workshop.session.id)
    authorize @workshop
    @session = @workshop.session
    @workshop.destroy
    position = 1
    @session.workshops.order(position: :asc).each do |workshop|
      workshop.update(position: position)
      position += 1
    end
    respond_to do |format|
      format.html {redirect_to training_session_path(@workshop.session.training, @workshop.session)}
      format.js
    end
  end

  def save
    @content = Content.new(@workshop.attributes.except("id", "position", "session_id", "created_at", "updated_at"))
    authorize @workshop
    if @content.save
      @workshop.workshop_modules.each do |mod|
        contentmod = ContentModule.new(mod.attributes.except("id", "user_id", "created_at", "updated_at", "workshop_id"))
        contentmod.content = @content
        contentmod.save
      end
      redirect_to training_session_workshop_path(@workshop.session.training, @workshop.session, @workshop)
      flash[:notice] = "Workshop saved in database."
      @success = true
    else
      flash[:alert] = "An error has occured."
    end
  end

  # Allows the ordering of workshops (position)
  def move_up
    authorize @workshop
    @session = @workshop.session
    unless @workshop.position == 1
      previous_workshop = @session.workshops.where(position: @workshop.position - 1).first
      previous_workshop.update(position: @workshop.position)
      @workshop.update(position: (@workshop.position - 1))
    end
    @workshop.save
    respond_to do |format|
      format.html {redirect_to training_session_path(@workshop.session.training, @workshop.session)}
      format.js
    end
  end

  # Allows the ordering of workshops (position)
  def move_down
    authorize @workshop
    @session = @workshop.session
    unless @workshop.position == Workshop.where(session_id: @session.id).count
      next_workshop = @session.workshops.where(position: @workshop.position + 1).first
      next_workshop.update(position: @workshop.position)
      @workshop.update(position: (@workshop.position + 1))
    end
    @workshop.save
    respond_to do |format|
      format.html {redirect_to training_session_path(@workshop.session.training, @workshop.session)}
      format.js
    end
  end

  # "View" mode
  def viewer
    authorize @workshop
  end

  def copy_form
    authorize @workshop
  end

  # Allows to create a copy of a Workshop into targeted Session
  def copy
    authorize @workshop
    if params[:copy_here].present?
      new_workshop = Workshop.new(@workshop.attributes.except("id", "created_at", "updated_at"))
      new_workshop.title = params[:copy][:rename] if params[:copy][:rename].present?
      new_workshop.position = new_workshop.session.workshops.count + 1
    else
      # Targeted Session
      session = Session.find(params[:copy][:session_id])
      # Creates the copy, and rename it if applicable
      new_workshop = Workshop.new(@workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
      new_workshop.title = params[:copy][:rename] if params[:copy][:rename].present?
      new_workshop.session_id = session.id
      new_workshop.position = session.workshops.count + 1
    end
    if new_workshop.save
      # Creates a copy of all WorkshopModules from the source
      @workshop.workshop_modules.each do |mod|
        modul = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id"))
        modul.update(workshop_id: new_workshop.id, position: mod.position)
      end
      j = 1
      new_workshop.workshop_modules.order(position: :asc).each{|mod| mod.update(position: j); j += 1}
      redirect_to training_session_path(session.training, session)
    else
      raise
    end
  end

  private

  def set_module
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:session_id, :title, :duration, :description, :theme_id)
  end
end
