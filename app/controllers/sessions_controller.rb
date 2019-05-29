class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  def index
    @project = Project.find(params[:project_id])
    @sessions = Session.where(project: @project)
    @sessions = policy_scope(Session).order(:date)
  end

  def show
    @session = Session.find(params[:id])
    authorize @session
    @contents = Content.all
    @comment = Comment.new
    @chapter = []
    @contents.each do |content|
      @chapter << content.chapter
    end
  end

  def new
    @session = Session.new
    # @clients = ClientContact.all
    @project = Project.find(params[:project_id])
    authorize @session
  end

  def create
    @project = Project.find(params[:project_id])
    @session = Session.new(session_params)
    authorize @session
    @session.project = @project
    if @session.save
      redirect_to project_session_path(@project, @session)
    else
      render :new
    end
  end

  def edit
    authorize @session
  end

  def update
    authorize @session
    @session.update(session_params)
    if @session.save
      redirect_to session_path(@session)
    else
      render "_edit"
    end
  end

  def destroy
    @session.destroy
    authorize @session
    redirect_to sessions_path
  end

  private

  def set_session
    @session = Session.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:title, :date, :start_time, :end_time, :project_id)
  end
end
