class SessionTrainersController < ApplicationController
  def create
    @user = User.find(params[:session_trainer][:user].to_s)
    @session = Session.find(params[:session_id])
    @session_trainer = SessionTrainer.new(user: @user, session: @session)
    authorize @session_trainer
    if @session_trainer.save
      redirect_to project_session_path(@session.project, @session)
    else
      raise
    end
  end
end
