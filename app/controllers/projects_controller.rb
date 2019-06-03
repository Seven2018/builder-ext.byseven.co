class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
    @projects = policy_scope(Project)
  end

  def show
    authorize @project
    @project_ownership = ProjectOwnership.new
    @users = User.all
  end

  def new
    @project = Project.new
    @project_ownership = ProjectOwnership.new
    @clients = ClientContact.all
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    @project_ownership = ProjectOwnership.new(user: current_user, project: @project)
    authorize @project
    if @project.save && @project_ownership.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project
    @project.update(project_params)
    if @project.save
      redirect_to project_path(@project)
    else
      render "_edit"
    end
  end

  def destroy
    @project.destroy
    authorize @project
    redirect_to projects_path
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :start_date, :end_date, :participant_number, :client_contact_id)
  end
end
