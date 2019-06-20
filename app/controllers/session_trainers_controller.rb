class SessionTrainersController < ApplicationController
  def create
    @user = User.find(params[:session_trainer][:user].to_s)
    @session = Session.find(params[:session_id])
    @session_trainer = SessionTrainer.new(user: @user, session: @session)
    authorize @session_trainer
    unless @session.users.include?(@user)
      if @session_trainer.save
        redirect_to project_session_path(@session.project, @session)
      else
        raise
      end
    else
      redirect_to project_session_path(@session.project, @session)
    end
  end
end
