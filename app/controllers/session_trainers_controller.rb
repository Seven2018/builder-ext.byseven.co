class SessionTrainersController < ApplicationController
  def create
    @session_trainer = SessionTrainer.new
    authorize @session_trainer
    @session = Session.find(params[:session_id])
    array = params[:session][:user_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if SessionTrainer.where(session_id: @session.id, user_id: ind).empty?
        SessionTrainer.create(session_id: @session.id, user_id: ind)
      end
    end
    (User.ids - array).each do |ind|
      unless SessionTrainer.where(session_id: @session.id, user_id: ind).empty?
        SessionTrainer.where(session_id: @session.id, user_id: ind).first.destroy
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @user = User.find(params[:user_id])
    @session = Session.find(params[:session_id])
    @session_trainer = SessionTrainer.where(user: @user).where(session: @session)
    skip_authorization
    @session_trainer.first.destroy
    redirect_back(fallback_location: root_path)
  end
end
