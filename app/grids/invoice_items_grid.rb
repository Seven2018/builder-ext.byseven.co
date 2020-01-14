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
    total = 0
    record.training.sessions.each do |session|
      total += session.duration
    end
    total
  end
  column(:nature) do |record|
    if record.client_company.client_company_type == 'Entreprise'
      'j'
    else
      'h'
    end
  end
  column(:pu, header: '€/u') do |record|
    record.invoice_lines.first.net_amount.round if record.invoice_lines.first.net_amount.present?
  end
  column(:CAV, header: 'CA variable') do |record|
    (record.invoice_lines.first.quantity * record.invoice_lines.first.net_amount).round if (record.invoice_lines.first.net_amount.present? && record.invoice_lines.first.quantity.present?)
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
  column :sending_date do
    self.sending_date.to_date.strftime('%d/%m/%y') if self.sending_date.present?
  end
  column :dunning_date do
    self.dunning_date.to_date.strftime('%d/%m/%y') if self.dunning_date.present?
  end
  column :payment_date do
    self.payment_date.to_date.strftime('%d/%m/%y') if self.payment_date.present?
  end
  column(:trainers, header: 'Intervenants') do |record|
    if record.uuid[0] == 'F'
      result = []
      record.training.invoice_items.where(type: 'InvoiceSevener').each do |order|
        result << "#{order.user.firstname} #{order.user.lastname}"
      end
      result.join('-')
    end
  end

  def total_sum
    x = 1
    y = self.data.count
    sum = 0
    while x < y do
      sum += self.data[x][12]
      x += 1
    end
    sum
  end

  def total_days
    x = 1
    y = self.data.count
    sum = 0
    while x < y do
        sum += self.data[x][4] if self.data[x][5] == 'j'
        x += 1
    end
    sum
  end

  def total_hours
    x = 1
    y = self.data.count
    sum = 0
    while x < y do
        sum += self.data[x][4] if self.data[x][5] == 'h'
        x += 1
    end
    sum
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end
end
