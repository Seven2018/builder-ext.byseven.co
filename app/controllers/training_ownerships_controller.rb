class TrainingOwnershipsController < ApplicationController

  # Allows management of TrainingOwners through a checkbox collection
  def create
    skip_authorization
    @training = Training.find(params[:training_id])
    # Select all Users whose checkbox is checked and create a TrainingOwner
    array = params[:training][:owner_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if TrainingOwnership.where(training_id: @training.id, user_id: ind, user_type: 'Owner').empty?
        TrainingOwnership.create(training_id: @training.id, user_id: ind, user_type: 'Owner')
      end
    end
    # Select all Users whose checkbox is unchecked and destroy their TrainingOwner, if existing
    (User.ids - array).each do |ind|
      unless TrainingOwnership.where(training_id: @training.id, user_id: ind, user_type: 'Owner').empty?
        TrainingOwnership.where(training_id: @training.id, user_id: ind, user_type: 'Owner').first.destroy
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def new_writer
    skip_authorization
    @training = Training.find(params[:training_id])
    # Select all Users whose checkbox is checked and create a TrainingOwner
    array = params[:training][:writer_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if TrainingOwnership.where(training_id: @training.id, user_id: ind, user_type: 'Writer').empty?
        TrainingOwnership.create(training_id: @training.id, user_id: ind, user_type: 'Writer')
      end
    end
    # Select all Users whose checkbox is unchecked and destroy their TrainingOwner, if existing
    (User.ids - array).each do |ind|
      unless TrainingOwnership.where(training_id: @training.id, user_id: ind, user_type: 'Writer').empty?
        TrainingOwnership.where(training_id: @training.id, user_id: ind, user_type: 'Writer').first.destroy
      end
    end
    redirect_back(fallback_location: root_path)
  end
end
