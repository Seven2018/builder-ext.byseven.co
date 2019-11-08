class TrainingOwnershipsController < ApplicationController

  # Allows management of TrainingOwners through a checkbox collection
  def create
    skip_authorization
    @training = Training.find(params[:training_id])
    # Select all Users whose checkbox is checked and create a TrainingOwner
    array = params[:training][:user_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if TrainingOwnership.where(training_id: @training.id, user_id: ind).empty?
        TrainingOwnership.create(training_id: @training.id, user_id: ind)
      end
    end
    # Select all Users whose checkbox is unchecked and destroy their TrainingOwner, if existing
    (User.ids - array).each do |ind|
      unless TrainingOwnership.where(training_id: @training.id, user_id: ind).empty?
        TrainingOwnership.where(training_id: @training.id, user_id: ind).first.destroy
      end
    end
    redirect_back(fallback_location: root_path)
  end
end
