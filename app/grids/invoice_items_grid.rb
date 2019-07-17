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
  filter :training_id, header: 'Formation' do |value|
    InvoiceItem.joins(:training).where('title LIKE ?', "%#{value}%")
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
  column(:training, header: 'Nom Formation') do |record|
    record.training.title
  end
  column(:u) do |record|
    record.invoice_lines.first.quantity
  end
  column(:nature) do |record|
    if record.client_company.client_company_type == 'Entreprise'
      'j'
    else
      'h'
    end
  end
  column(:pu, header: '€/u') do |record|
    record.invoice_lines.first.net_amount.round
  end
  column(:CAV, header: 'CA variable') do |record|
    (record.invoice_lines.first.quantity * record.invoice_lines.first.net_amount).round
  end
  column(:preparation, header: 'CA fixe') do |record|
    preparation = 0
    record.invoice_lines.each do |line|
      if line.product && line.product.product_type == 'Préparation'
        preparation += line.quantity * line.net_amount
      end
    end
    preparation.round
  end
  column(:deposit, header: 'Caution') do |record|
    deposit = 0
    record.invoice_lines.each do |line|
      if line.product && line.product.product_type == 'Caution'
        deposit += line.quantity * line.net_amount
      end
    end
    deposit.round
  end
  column(:vat, header: 'TVA') do |record|
    record.tax_amount.round
  end
  column(:costs, header: 'Frais facturés') do |record|
    costs = 0
    record.invoice_lines.each do |line|
      if line.product && line.product.product_type == 'Frais'
        costs += line.quantity * line.net_amount
      end
    end
    costs.round
  end
  column(:CAT, header: 'CA facturé') do |record|
    (record.total_amount - record.tax_amount).round
  end
  column :uuid
  column :created_at do
    self.created_at.to_date.strftime('%d/%m/%y')
  end
  column :sending_date
  column :description
  column :payment_date
  column(:trainers, header: 'Intervenants') do |record|
    if record.uuid[0] == 'F'
      result = []
      record.training.invoice_items.where(type: 'InvoiceSevener').each do |order|
        result << "#{order.user.firstname} #{order.user.lastname}"
      end
      result.join('-')
    end
  end
end
