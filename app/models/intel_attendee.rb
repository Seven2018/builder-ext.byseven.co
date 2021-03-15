Airrecord.api_key = Rails.application.credentials.airtable_key

class IntelAttendee < Airrecord::Table
  self.base_key = 'appBGyYCSfVCX9YVA'
  self.table_name = 'Attendees'
end
