Airrecord.api_key = Rails.application.credentials.airtable_key

class OverviewNumbersActivity < Airrecord::Table
  self.base_key = 'appGm0wPMcSxAI6RH'
  self.table_name = 'Numbers : Activity'
end
