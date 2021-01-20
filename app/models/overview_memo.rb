Airrecord.api_key = Rails.application.credentials.airtable_key

class OverviewMemo < Airrecord::Table
  self.base_key = 'appGm0wPMcSxAI6RH'
  self.table_name = 'Memos'
end
