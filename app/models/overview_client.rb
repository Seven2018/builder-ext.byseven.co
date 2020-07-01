Airrecord.api_key = Rails.application.credentials.airtable_key

class OverviewClient < Airrecord::Table
  self.base_key = 'appGm0wPMcSxAI6RH'
  self.table_name = 'Customers'

  has_many :overview_contact, class: "OverviewContact", column: "Name"
  has_many :overview_card, class: "OverviewCard", column: "Title"
end
