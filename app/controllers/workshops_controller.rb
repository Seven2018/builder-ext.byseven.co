class WorkshopsController < ApplicationController
  before_action :set_module, only: [:show, :edit, :update, :destroy, :move, :move_up, :move_down, :save, :viewer]

  def show
    authorize @workshop
    @theory_workshop = TheoryWorkshop.new
  end

  def create
    @content = Content.find(params[:content_id])
    @session = Session.find(params[:session_id])
    @workshop = Workshop.new(@content.attributes.except("id", "created_at", "updated_at"))
    authorize @workshop
    @workshop.session = @session
    i = 1
    if @workshop.save
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

  def move_up
    authorize @workshop
    @session = @workshop.session
    array = []
    @session.workshops.order('position ASC').each do |workshop|
      array << workshop
    end
    unless @workshop.position == 1
      array.insert((@workshop.position - 2), array.delete_at(@workshop.position - 1))
    end
    array.compact.each do |workshop|
      workshop.update(position: array.index(workshop) + 1)
    end
    @workshop.save
    respond_to do |format|
      format.html {redirect_to training_session_path(@workshop.session.training, @workshop.session)}
      format.js
    end
  end

  def move_down
    authorize @workshop
    @session = @workshop.session
    array = []
    @session.workshops.order('position ASC').each do |workshop|
      array << workshop
    end
    unless @workshop.position == array.compact.count
      array.insert((@workshop.position), array.delete_at(@workshop.position - 1))
    end
    array.compact.each do |workshop|
      workshop.update(position: array.index(workshop) + 1)
    end
    @workshop.save
    respond_to do |format|
      format.html {redirect_to training_session_path(@workshop.session.training, @workshop.session)}
      format.js
    end
  end

  # def move
  #   authorize @workshop
  #   @session = @workshop.session
  #   if @workshop.insert_at(params[:position].to_i)
  #   else
  #     raise
  #   end
  # end

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
