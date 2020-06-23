Airrecord.api_key = Rails.application.credentials.airtable_key

class Sevener < Airrecord::Table
  self.base_key = 'appDqvNoJM7O4nFdn'
  self.table_name = 'Seveners'

  def fullname
    self['Nom Complet']
  end
end
