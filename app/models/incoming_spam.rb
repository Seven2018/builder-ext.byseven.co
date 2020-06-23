Airrecord.api_key = Rails.application.credentials.airtable_key

class IncomingSpam < Airrecord::Table
  self.base_key = 'appNwEL8Z8OMPTwSA'
  self.table_name = 'Spams'
end
