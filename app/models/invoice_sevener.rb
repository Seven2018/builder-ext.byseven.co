Airrecord.api_key = Rails.application.credentials.airtable_key

class InvoiceSevener < Airrecord::Table
  self.base_key = 'appDqvNoJM7O4nFdn'
  self.table_name = 'Invoices'
end
