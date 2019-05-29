class ProjectOwnershipsController < ApplicationController
  def create
    @user = User.find(params[:project_ownership][:user].to_s)
    @project = Project.find(params[:project_id])
    @ownership = ProjectOwnership.new(user: @user, project: @project)
    skip_authorization
    if @ownership.save
      redirect_to project_path(@project)
    else
      raise
    end
  end
end
