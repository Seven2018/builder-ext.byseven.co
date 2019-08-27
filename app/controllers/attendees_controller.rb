class AttendeesController < ApplicationController
  before_action :set_training, only: [:form, :create, :destroy]
  before_action :authenticate_user!, except: [:form, :create, :destroy]

  def form
    @attendee = Attendee.new
    authorize @attendee
    @info = {}
    if params[:search] && params[:search][:email]
      @sessions = @training.sessions
      @info = {firstname: params[:search][:firstname].capitalize, lastname: params[:search][:lastname].upcase, email: params[:search][:email].downcase, employee_id: params[:search][:employee_id]}
    end
  end

  def create
    @attendee = Attendee.new(firstname: params[:firstname], lastname: params[:lastname], email: params[:email], employee_id: params[:employee_id], session_id: params[:session_id])
    authorize @attendee
    if @attendee.save
      redirect_to training_path(@training)
    else
      render :form
    end
  end

  def destroy
    @attendee = Attendee.find(params[:id])
    authorize @attendee
    @attendee.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_training
    @training = Training.find(params[:training_id])
  end
end
