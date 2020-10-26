class InvoiceItem < ApplicationRecord
  belongs_to :client_company, optional: true
  belongs_to :training, optional: true
  belongs_to :user, optional: true
  has_one :session_trainers
  has_many :invoice_lines, dependent: :destroy
  self.inheritance_column = :_type_disabled

  def self.to_csv
    attributes = %w(Date Journal Compte_Général Compte_Auxiliaire Référence Libellé Débit Crédit)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |item|
        if item.type == 'Invoice'
          date = item.created_at.strftime('%d/%m/%Y')
          journal = 'VE'
          gen_account = '41100000'
          aux_account = item.client_company.reference
          invoice_num = item.uuid
          if item.client_company.client_company_type == 'School'
            company_label = "#{item.client_company.name}"
          else
            if item.training.client_contact.billing_contact.present? && (item.client_company == item.training.client_company)
              company_label = "#{item.training.client_contact.billing_contact} TVA"
            else
              company_label = "#{item.client_company.name} TVA"
            end
          end
          debit = item.total_amount
          csv << [date, journal, gen_account, aux_account, invoice_num, company_label, debit, '']
          item.invoice_lines.each do |line|
            if line.product&.reference.present?
              credit = line&.net_amount * line&.quantity
              csv << [date, journal, line.product&.reference, '', invoice_num, company_label, '', credit]
            end
          end
          csv << [date, journal, '44571130', '', invoice_num, company_label, '', item.tax_amount] if item.tax_amount?
        end
      end
    end
  end

  def gross_revenue
    self.total_amount - self.tax_amount
  end

  def products
    self.invoice_lines.map(&:product)
  end

  def self.numbers_scope(starts_at = Date.today.beginning_of_year, ends_at = Date.today)
    InvoiceItem.where(type: 'Invoice').where('created_at < ?', ends_at).where('created_at > ?', starts_at)
  end

  def self.numbers_sales_csv(starts_at, ends_at)
    attributes = %w(Title Client Unit Unit_type Unit_price Variable_revenue Fixed_revenue Deposit Tax Billed_expenses Other_expenses Billed_revenue Invoice_number Created_at Sending_date Dunning_date Payment_date Comments)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |item|
        title = item.training.title
        client = item.training.client_company.name
        unit = item.invoice_lines.where(product_id: [1,2])&.order(position: :asc)&.first&.quantity
        item.training.client_company.client_company_type == 'School' ? unit_type = "h" : unit_type = "d"
        unit_price = item.invoice_lines.where(product_id: [1,2])&.order(position: :asc)&.first&.quantity.net_amount
        var_revenue = unit * unit_price
        fixed_revenue = 0
        item.invoice_lines.where(product_id: 3).each do |line|
          fixed_revenue += line&.quantity * line&.net_amount
        end
        deposit = 0
        item.invoice_lines.where(product_id: 8).each do |line|
          deposit += line&.quantity * line&.net_amount
        end
        tax = item.tax_amount
        billed_exp = 0
        item.invoice_lines.where(product_id: [4,5,6]).each do |line|
          billed_exp += line&.quantity * line&.net_amount
        end
        other_exp = ""
        billed_revenue = var_revenue + fixed_revenue + billed_exp
        uuid = item.uuid
        created_at = item.created_at.strftime('%d/%m/%Y')
        sending_date = item.sending_date&.strftime('%d/%m/%Y')
        dunning_date = item.dunning_date&.strftime('%d/%m/%Y')
        payment__date = item.payment_date&.strftime('%d/%m/%Y')
        comments = ""
        csv << [title, client, unit, unit_type, unit_price, var_revenue, fixed_revenue, deposit, tax, billed_exp, other_exp, billed_revenue, uuid, created_at, sending_date, dunning_date, payment_date, comments]
      end
    end
  end

  # Exports the data to Airtable DB
  def export_numbers_revenue
    begin
      return if self.type != 'Invoice'
      training = OverviewTraining.all.select{|x| x['Builder_id'] == self.training.id}&.first
      invoice = OverviewNumbersRevenue.all.select{|x| x['Invoice_id'] == self.id}&.first
      unless invoice.present?
        invoice = OverviewNumbersRevenue.create('Training' => [training&.id], 'Invoice SEVEN' => self.uuid, 'Issue Date' => Date.today.strftime('%Y-%m-%d'), 'Invoice_id' => self.id)
      end
      lines = []
      if self.products.include?(Product.find(1))
        lines = self.invoice_lines.select{|x| x.product_id == 1}
      elsif self.products.include?(Product.find(2))
        lines = self.invoice_lines.select{|x| x.product_id == 2}
      elsif self.products.include?(Product.find(7))
        lines = self.invoice_lines.select{|x| x.product_id == 7}
      else
        invoice['Unit Number'] = 0
      end

      lines.present? ? invoice['Unit Price'] = (lines.map{|x| x&.net_amount}&.sum / lines&.length).to_f : invoice['Unit Price'] = 0
      invoice['Unit Number'] = lines.map{|x| x&.quantity}&.sum
      if self.products.include?(Product.find(3))
        lines = self.invoice_lines.select{|x| x.product_id == 3}
        invoice['Preparation'] = lines.map{|x| x.net_amount * x.quantity}.sum.to_f
      end
      if self.products.include?(Product.find(8))
        lines = self.invoice_lines.select{|x| x.product_id == 8}
        invoice['Deposit'] = lines.map{|x| x.net_amount * x.quantity}.sum.to_f
      end
      expenses = self.products.compact.select{|x| [4,5,6].include?(x.id)}
      if expenses.present?
        lines = self.invoice_lines.select{|x| expenses.include?(x.product)}
        invoice['Billed Expenses'] = lines.map{|x| x.net_amount * x.quantity}.sum.to_f
      end
      self.update_price
      invoice['Former / Credit / New'] = 'Credit' if self.total_amount < 0
      invoice['VAT'] = self.tax_amount.to_f
      invoice['OPCO'] = self.client_company.name if self.client_company.client_company_type == 'OPCO'
      invoice['Training_id'] = self.training.id
      self.payment_date.present? ? invoice['Paid'] = true : invoice['Paid'] = false
      self.training.export_airtable
      invoice.save
    rescue
    end
  end

  # Updates InvoiceItem price and tax amount
  def update_price
    total = 0
    tax = 0
    self.invoice_lines.each do |line|
      if !line.quantity.nil? && !line.net_amount.nil? && !line.tax_amount.nil?
        total += line.quantity * line.net_amount * (1 + line.tax_amount/100)
        tax += line.quantity * line.net_amount * (line.tax_amount/100)
      end
    end
    self.update(total_amount: total, tax_amount: tax)
    self.save
  end
end
