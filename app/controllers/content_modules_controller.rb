class ContentModulesController < ApplicationController
  before_action :set_module, only: [:show, :edit, :update, :destroy, :move]

  def show
    authorize @module
  end

  def create
    raise
    @content = Content.find(params[:content_id])
    @session = Session.find(params[:session_id])
    @module = ContentModule.new(@content.attributes.except("id", "created_at", "updated_at"))
    authorize @module
    @module.session = @session
    @module.save
    raise
    respond_to do |format|
      format.html {redirect_to project_session_path(@session.project, @session)}
      format.js
    end
    # Comment.create(message: "Log | Module #{@module.title} added |", user_id: current_user.id, session_id: @module.session.id)
  end

  def edit
    authorize @module
  end

  def update
    params = @module.attributes
    authorize @module
    @module.update(mod_params)
    if @module.save
      # comment = Comment.create(message: "Log | Module #{@module.title} updated | from #{params.except('id', 'created_at', 'updated_at', 'session_id')} to #{@module.attributes.except('id', 'created_at', 'updated_at', 'session_id')}",
      #                user_id: current_user.id, session_id: @module.session.id)
      redirect_to project_session_path(@module.session.project, @module.session)
    else
      render :edit
    end
  end

  def destroy
    # Comment.create(message: "Log | Module #{@module.title} removed |", user_id: current_user.id, session_id: @module.session.id)
    authorize @module
    @module.destroy
    redirect_to project_session_path(@module.session.project, @module.session)
  end

  def move
    authorize @module
    @session = @module.session
    @module.insert_at(params[:position].to_i)
  end

  private

  def set_module
    @module = ContentModule.find(params[:id])
  end

  def mod_params
    params.require(:mod).permit(:session_id, :title, :duration, :format, :description, :intel1, :intel2, :chapter)
  end
end
