class SessionAttendeesController < ApplicationController
  before_action :authenticate_user!, except: [:destroy, :create, :create_kea_partners, :destroy_kea_partners, :test]

  def link_attendees
    skip_authorization
    session = Session.find(params[:id])
    attendee_ids = params[:session][:attendee_ids][1..-1]
    attendee_ids.each do |attendee_id|
      SessionAttendee.create(session_id: session.id, attendee_id: attendee_id)
    end
    redirect_to training_session_path(session.training, session)
    flash[:notice] = "Participants added to #{session.title}"
  end

  def link_attendees_to_training
    skip_authorization
    training = Training.find(params[:id])
    attendee_ids = params[:link][:attendee_ids][1..-1]
    attendee_ids.each do |attendee_id|
      training.sessions.each do |session|
        SessionAttendee.create(session_id: session.id, attendee_id: attendee_id)
      end
    end
    redirect_to training_path(training)
    flash[:notice] = "Participants added to #{training.title}"
  end

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
    @session = Session.find(params[:session_id])
    @attendee = Attendee.find(params[:attendee_id])
    @session_attendee = SessionAttendee.create(session_id: @session.id, attendee_id: params[:attendee_id])
    authorize @session_attendee
    # flash[:notice] = "Vous êtes désormais inscrit à la formation #{Session.find(sessions.first).training.title.split('-').last}."
    respond_to do |format|
      format.html {redirect_back(fallback_location: root_path)}
      format.js
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy_kea_partners
    @session_attendee = SessionAttendee.find_by(session_id: params[:session_id], attendee_id: params[:attendee_id])
    authorize @session_attendee
    @session_attendee.destroy
    # flash[:notice] = "Vous êtes désinscrit de la formation #{Session.find(sessions.first).training.title.split('-').last}."
    redirect_back(fallback_location: root_path)
  end

  # def test
  #   skip_authorization
  #   raise
  #   sessions_ids = params[:sessions_ids].split(',').map{|x|x.to_i}
  #   if params[:create_attendees][:choice] == 'Interested'
  #     new_interest = AttendeeInterest.create(session_id: params[:sessions_ids], attendee_id: params[:attendee_id])
  #     SessionAttendee.where(attendee_id: params[:attendee_id], session_id: sessions_ids).destroy_all
  #   elsif params[:create_attendees][:choice] == 'Not interested'
  #     AttendeeInterest.where(session_id: params[:sessions_ids], attendee_id: params[:attendee_id]).destroy_all
  #     SessionAttendee.where(attendee_id: params[:attendee_id], session_id: sessions_ids).destroy_all
  #   else
  #     AttendeeInterest.where(session_id: params[:sessions_ids], attendee_id: params[:attendee_id]).destroy_all
  #     SessionAttendee.where(attendee_id: params[:attendee_id], session_id: sessions_ids).destroy_all
  #     session_attendee = SessionAttendee.create(session_id: params[:create_attendees][:choice].to_i, attendee_id: params[:attendee_id])
  #   end
  #   redirect_back(fallback_location: root_path)
  #   if params[:create_attendees][:choice] == 'Interested'
  #     flash[:notice] = "Votre interêt pour la formation #{training.title} a bien été pris en compte."
  #   elsif params[:create_attendees][:choice] == 'Not interested'
  #   else
  #     flash[:notice] = "Vous êtes désormais inscrit à la session #{session_attendee.session.title} du #{session_attendee.session.date.strftime('%d/%m/%Y')}."
  #   end
  # end

  def test
    skip_authorization
    params[:create_attendees].each do |choice, value|
      sessions_ids = eval(params[:sessions_ids])[choice.to_sym]
      if value == 'Interested'
        new_interest = AttendeeInterest.create(session_id: sessions_ids.first, attendee_id: params[:attendee_id])
        SessionAttendee.where(attendee_id: params[:attendee_id], session_id: sessions_ids).destroy_all
      elsif value == 'Not interested'
        AttendeeInterest.where(session_id: sessions_ids, attendee_id: params[:attendee_id]).destroy_all
        SessionAttendee.where(attendee_id: params[:attendee_id], session_id: sessions_ids).destroy_all
      else
        AttendeeInterest.where(session_id: sessions_ids, attendee_id: params[:attendee_id]).destroy_all
        SessionAttendee.where(attendee_id: params[:attendee_id], session_id: sessions_ids).destroy_all
        new_session_attendee = SessionAttendee.create(session_id: value.to_i, attendee_id: params[:attendee_id])
        # NewAttendeeMailer.with(user: User.find(2)).new_attendee(new_session_attendee).deliver
      end
    end
    redirect_to kea_partners_thanks_path(search: {email: Attendee.find(params[:attendee_id]).email})
  end
end

