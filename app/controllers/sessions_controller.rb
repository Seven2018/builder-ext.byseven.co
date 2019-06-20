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
    @session_trainer = SessionTrainer.new
    @comment = Comment.new
    @chapter = []
    @contents.each do |content|
      @chapter << content.chapter
    end
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@session.title}",
          layout: 'pdf.html.erb',
          template: 'sessions/show',
          # title: "#{@session.title}",
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
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    authorize @session
  end

  def update
    @project = Project.find(params[:project_id])
    authorize @session
    @session.update(session_params)
    if @session.save
      redirect_to project_session_path(@project, @session)
    else
      render "_edit"
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    authorize @session
    @session.destroy
    redirect_to project_path(@project)
  end

  private

  def set_session
    @session = Session.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:title, :date, :start_time, :end_time, :project_id)
  end
end
