class TrainingOwnershipsController < ApplicationController
  def create
    @user = User.find(params[:training_ownership][:user].to_s)
    @training = Training.find(params[:training_id])
    @ownership = TrainingOwnership.new(user: @user, training: @training)
    skip_authorization
    unless @training.users.include?(@user)
      if @ownership.save
        redirect_to training_path(@training)
      else
        raise
      end
    else
      redirect_to training_path(@training)
    end
  end

  def destroy
    @user = User.find(params[:training_ownership][:user].to_s)
    @training = Training.find(params[:training_id])
    @ownership = TrainingOwnership.where(user: @user).where(training: @training)
    skip_authorization
    @ownership.first.destroy
    redirect_to training_path(@training)
  end
end
