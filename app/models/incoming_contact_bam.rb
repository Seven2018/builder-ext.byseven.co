Airrecord.api_key = Rails.application.credentials.airtable_key

class IncomingContactBam < Airrecord::Table
  self.base_key = 'appNwEL8Z8OMPTwSA'
  self.table_name = 'Contacts SEVEN x BAM'
end
