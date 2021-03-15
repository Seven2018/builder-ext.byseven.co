Airrecord.api_key = Rails.application.credentials.airtable_key

class IntelEvent < Airrecord::Table
  self.base_key = 'appBGyYCSfVCX9YVA'
  self.table_name = 'Events'
end
