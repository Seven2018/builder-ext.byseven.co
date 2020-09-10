Airrecord.api_key = Rails.application.credentials.airtable_key

class OverviewIntervention < Airrecord::Table
  self.base_key = 'appGm0wPMcSxAI6RH'
  self.table_name = 'Interventions'
end
