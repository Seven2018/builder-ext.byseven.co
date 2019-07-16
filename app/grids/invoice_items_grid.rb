class InvoiceItemsGrid
  include Datagrid

  #
  # Scope
  #

  scope {
    InvoiceItem.order('uuid ASC')
  }

  #
  # Filters
  #

  filter :client_company_id, :header => 'Client' do |value|
    InvoiceItem.joins(:client_company).where('lower(name) LIKE ?', "%#{value}%").or(InvoiceItem.joins(:client_company).where('upper(name) LIKE ?', "%#{value}%"))
  end
  filter :created_at, :date, :range => true, header: 'Emission facture'

  #
  # Columns
  #

  column(:start_date, header: 'Début') do |record|
    record.training.start_date.strftime('%d/%m/%y')
  end
  column(:end_date, header: 'Fin') do |record|
    record.training.end_date.strftime('%d/%m/%y')
  end
  column(:client_company, header: 'Nom client') do |record|
    record.client_company.name
  end
  column :uuid
  column :created_at do
    self.created_at.to_date.strftime('%d/%m/%y')
  end
end
