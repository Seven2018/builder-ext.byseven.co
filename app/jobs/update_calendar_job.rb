class UpdateCalendarJob < ApplicationJob
  include SuckerPunch::Job

  def perform(client, code, state, training)
    # Gets clearance from OAuth
    skip_authorization
    client.code = code
    client.update!(client.fetch_access_token!)
    # Initiliaze GoogleCalendar
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    # Get the targeted session
    command = Base64.decode64(state).split('|').first
    # Calendars ids
    calendars_ids = { 1 => 'yahya.fallah@byseven.co', 2 => 'brice.chapuis@byseven.co', 3 => 'thomas.fraudet@byseven.co', 4 => 'jorick.roustan@byseven.co', 5 => 'mathilde.meurer@byseven.co', 'other' => 'vum1670hi88jgei65u5uedb988@group.calendar.google.com'}

    # Lists the users and the events ids of the events to be deleted
    to_delete_string = Base64.decode64(state).split('|').last.split('%').last

    # Deletes the events
    to_delete_string.split(',').each do |pair|
      key = pair.split(':')[0]
      value = pair.split(':')[1]
      begin
        if %w(1 2 3 4 5).include?(key)
          service.delete_event(calendars_ids[key.to_i], value) if value.present?
        else
          service.delete_event(calendars_ids['other'], value) if value.present?
        end
      rescue
      end
    end


    if command[0...-1] == 'purge_session'
      Session.where(id: session_ids).destroy_all
      redirect_to training_path(training)
      return
    elsif command[0...-1] == 'purge_training'
      training.destroy
      redirect_to trainings_path(page: 1)
      return
    else
      # Lists the users for whom an event will be created
      list = command.split(',')
      # Creates the event in all the targeted calendars
      list.each do |ind|
        Session.where(id: session_ids).each do |session|
          day = session&.date
          events = []
          begin
            break_position = session.workshops.find_by(title: 'Pause Déjeuner')&.position
            if break_position.nil?
              # Creates the event to be added to one or several calendars
              events << Google::Apis::CalendarV3::Event.new({
                start: {
                  date_time: day.to_s+'T'+session.start_time.strftime('%H:%M:%S'),
                  time_zone: 'Europe/Paris',
                },
                end: {
                  date_time: day.to_s+'T'+session.end_time.strftime('%H:%M:%S'),
                  time_zone: 'Europe/Paris',
                },
                summary: session.training.client_company.name + " - " + session.training.title
              })
            else
              morning = [session.start_time]
              morning_duration = session.workshops.where('position < ?', break_position).map(&:duration).sum
              morning << session.start_time + morning_duration.minutes
              afternoon = [session.end_time - session.workshops.where('position > ?', break_position).map(&:duration).sum.minutes, session.end_time]
              [morning, afternoon].each do |event|
                events << Google::Apis::CalendarV3::Event.new({
                start: {
                  date_time: day.to_s+'T'+event.first.strftime('%H:%M:%S'),
                  time_zone: 'Europe/Paris',
                },
                end: {
                  date_time: day.to_s+'T'+event.last.strftime('%H:%M:%S'),
                  time_zone: 'Europe/Paris',
                },
                summary: session.training.client_company.name + " - " + session.training.title
              })
              end
            end
            events.each do |event|
              if %w(1 2 3 4 5).include?(ind)
                create_calendar_id(ind, session.id, event, service, calendars_ids)
              else
                sevener = User.find(ind)
                initials = sevener.initials
                event.summary = session.training.client_company.name + " - " + session.training.title + " - " + initials
                event.id = SecureRandom.hex(32)
                session_trainer = SessionTrainer.where(user_id: sevener.id, session_id: session.id).first
                session_trainer.calendar_uuid.nil? ? session_trainer.update(calendar_uuid: event.id) : session_trainer.update(calendar_uuid: session_trainer.calendar_uuid + ' - ' + event.id)
                service.insert_event(calendars_ids['other'], event)
              end
            end
          rescue
          end
        end
      end
      return
    end
  end
end
