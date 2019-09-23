class TrainingOwnershipsController < ApplicationController
  def create
    skip_authorization
    @training = Training.find(params[:training_id])
    array = params[:training][:user_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if TrainingOwnership.where(training_id: @training.id, user_id: ind).empty?
        TrainingOwnership.create(training_id: @training.id, user_id: ind)
      end
    end
    (User.ids - array).each do |ind|
      unless TrainingOwnership.where(training_id: @training.id, user_id: ind).empty?
        TrainingOwnership.where(training_id: @training.id, user_id: ind).first.destroy
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @user = User.find(params[:user_id])
    @training = Training.find(params[:training_id])
    @ownership = TrainingOwnership.where(user: @user).where(training: @training).first
    skip_authorization
    @ownership.destroy
    redirect_back(fallback_location: root_path)
  end
end
