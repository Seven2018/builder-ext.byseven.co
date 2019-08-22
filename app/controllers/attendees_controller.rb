class AttendeesController < ApplicationController
  before_action :set_training, only: [:new, :create]

  def new
    @attendee = Attendee.new
    authorize @attendee
  end

  def create
    @attendee = Attendee.new(attendee_params)
    if @attendee.save
      redirect to training_path(@training)
    else
      render :new
    end
  end

  private

  def set_training
    @training = Training.find(params[:training_id])
  end

  def attendee_params
    params.require(:attendee).permit(:firstname, :lastname, :employee_id, :email, :session_id)
  end
end
