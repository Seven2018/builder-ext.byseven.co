class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :transform, :destroy]

  def index
    @bookings = policy_scope(Booking)
  end

  def show
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    authorize @booking
    @merchandise = Merchandise.find(params[:merchandise])
    # Links the Booking to current User
    @booking.user_id = current_user.id
    # Links the Booking to the Merchandise
    @booking.merchandise_id = @merchandise.id
    redirect_to trainings_path(tab: 'booking') if @booking.save
  end

  # Creates a Training from a Booking parameters
  def transform
    authorize @booking
    # If needed, create the ClientContact needed for creating a new Training
    if ClientContact.where(email: @booking.user.email).empty?
      ClientContact.create(name: "#{@booking.user.firstname.capitalize} #{@booking.user.lastname.upcase}", email: @booking.user.email, client_company_id: @booking.user.client_company.id)
    end
    @training = Training.new(title: "#{@booking.user.client_company.name} - #{@booking.merchandise.name}", start_date: @booking.start_date, end_date: @booking.end_date, mode: 'Company', booking_id: @booking.id)
    # Links the created Training to the ClientContact.
    @training.client_contact_id = ClientContact.find_by(email: @booking.user.email).id
    if @training.save
      @booking.update(completed: true)
      # Gives Ownership to the User doing the transformation
      TrainingOwnership.create(user_id: current_user.id, training_id: @training)
      redirect_to training_path(@training)
    else
      raise
    end
  end

  def destroy
    authorize @booking
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
