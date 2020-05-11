class AttendeeInterestsController < ApplicationController
    before_action :authenticate_user!, except: [:destroy, :create]

  def create
    skip_authorization
    training = Training.find(params[:training_id])
    AttendeeInterest.create(training_id: training.id, attendee_id: params[:attendee_id])
    flash[:notice] = "Votre interêt pour la formation #{training.title.split('-')[1]} est pris en compte."
    redirect_back(fallback_location: root_path)
  end

  def destroy
    skip_authorization
    training = Training.find(params[:training_id])
    @attendee_interest = AttendeeInterest.find_by(attendee_id: params[:attendee_id], training_id: training.id)
    @attendee_interest.destroy
    redirect_back(fallback_location: root_path)
  end
end
