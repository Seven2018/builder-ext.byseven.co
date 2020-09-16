Airrecord.api_key = Rails.application.credentials.airtable_key

class OverviewTraining < Airrecord::Table
  self.base_key = 'appGm0wPMcSxAI6RH'
  self.table_name = 'Trainings'
end
