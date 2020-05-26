class SessionAttendeesController < ApplicationController
  before_action :authenticate_user!, except: [:destroy, :create, :create_kea_partners, :destroy_kea_partners]

  def create
    @session = Session.find(params[:session_id])
    @attendee = Attendee.find(params[:attendee_id])
    @session_attendee = SessionAttendee.new(session_id: @session.id, attendee_id: params[:attendee_id])
    authorize @session_attendee
    if (@session.attendees.count <= (@session.attendee_number - 1)) && @session_attendee.save
      flash[:notice] = "Vous êtes désormais inscrit à la session #{@session_attendee.session.title}."
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @session_attendee = SessionAttendee.find_by(session_id: params[:session_id], attendee_id: params[:attendee_id])
    authorize @session_attendee
    @session_attendee.destroy
    flash[:notice] = "Vous êtes désinscrit de la session #{@session_attendee.session.title}."
    redirect_back(fallback_location: root_path)
  end

  def create_kea_partners
    skip_authorization
    sessions = params[:sessions_ids]
    sessions.each do |session|
      SessionAttendee.create(session_id: session, attendee_id: params[:attendee_id])
    end
    flash[:notice] = "Vous êtes désormais inscrit à la formation #{Session.find(sessions.first).training.title.split('-').last}."
    redirect_back(fallback_location: root_path)
  end

  def destroy_kea_partners
    skip_authorization
    sessions = params[:sessions_ids]
    sessions.each do |session|
      SessionAttendee.find_by(session_id: session, attendee_id: params[:attendee_id]).destroy
    end
    flash[:notice] = "Vous êtes désinscrit de la formation #{Session.find(sessions.first).training.title.split('-').last}."
    redirect_back(fallback_location: root_path)
  end
end
