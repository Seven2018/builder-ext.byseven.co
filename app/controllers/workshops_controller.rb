class WorkshopsController < ApplicationController
  before_action :set_module, only: [:show, :edit, :update, :destroy, :move, :save, :viewer]

  def show
    authorize @workshop
  end

  def create
    @content = Content.find(params[:content_id])
    @session = Session.find(params[:session_id])
    @workshop = Workshop.new(@content.attributes.except("id", "created_at", "updated_at"))
    authorize @workshop
    @workshop.session = @session
    i = 1
    if @workshop.save
      @content.content_modules.order('position ASC').each do |mod|
        wmod = WorkshopModule.new(mod.attributes.except("id", "position", "created_at", "updated_at", "content_id"))
        wmod.workshop = @workshop
        wmod.position = i
        i +=1
        wmod.save
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
    @workshop.destroy
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
      @success = true
    else
      raise
    end
  end

  def move
    authorize @workshop
    @session = @workshop.session
    if @workshop.insert_at(params[:position].to_i)
    else
      raise
    end
  end

  def viewer
    authorize @workshop
  end

  private

  def set_module
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:session_id, :title, :duration, :description, :theme_id)
  end
end
