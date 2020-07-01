class InvoiceItem < ApplicationRecord
  belongs_to :client_company, optional: true
  belongs_to :training, optional: true
  belongs_to :user, optional: true
  has_one :session_trainers
  has_many :invoice_lines, dependent: :destroy
  self.inheritance_column = :_type_disabled

  # def self.to_csv
  #   attributes = %w(Début Fin Nom_Client Nom_Formation Trello Unité Nature €/u CA_variable Ca_fixe Caution TVA Frais_facturés Frais_non_facturés Anc_Nouv CA_facturé Num_facture Emission Envoi Relance Paiement Intervenant Reception_Facture Montant Date_Paiement)
  #   CSV.generate(headers: true) do |csv|
  #     csv << attributes
  #     all.each do |item|
  #       startdate = item.training.start_date&.strftime('%d/%m/%y')
  #       enddate = item.training.end_date&.strftime('%d/%m/%y')
  #       client = item.client_company.name
  #       training_name = item.training.title
  #       trello = ''
  #       unit = 0
  #       unit_price = 0
  #       variable = 0
  #       fixed = 0
  #       caution = 0
  #       expenses = 0
  #       expenses_out = 0
  #       item.invoice_lines.each do |line|
  #         unit += line.quantity if ((line.product = Product.find(1) || line.product == Product.find(2) || line.product == Product.find(7) || line.product == Product.find(9)) && line.quantity.present?)
  #         unit_price += line.net_amount if ((line.product = Product.find(1) || line.product == Product.find(2)) && line.quantity.present? )
  #         variable += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present?)
  #         fixe += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Préparation')
  #         caution += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Caution')
  #         expenses += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Frais')
  #       end
  #       item.training.client_company.client_company_type == 'Company' ? nature = 'j' : nature = 'h'
  #       description = item.description
  #       vat = item.tax_amount
  #       revenue = item.total_amount
  #       num = item.uuid
  #       sending = item.sending_date&.strftime('%d/%m/%y') if item.sending_date.present?
  #       dunning = item.dunning_date&.strftime('%d/%m/%y') if item.dunning_date.present?
  #       payment = item.payment_date&.strftime('%d/%m/%y') if item.payment_date.present?
  #       csv << [startdate, enddate, client, training_name, trello, unit, nature, unit_price, variable, fixed, caution, vat, expenses, expenses_out, description, revenue, num, sending, dunning, payment]
  #       item.training.trainers.each do |trainer|
  #         csv << [startdate, enddate, client, training_name, trello, '', '', '', '', '', '', '', '', '', '', '', '', '', '', "","", "#{trainer.firstname} #{trainer.lastname}", '01/01/20', '480', '01/01/20']
  #       end
  #     end
  #   end
  # end

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
          if item.client_company.client_company_type = 'School'
            company_label = "#{item.client_company.name}"
          else
            if item.client_contact.billing_contact.present?
              company_label = "#{item.client_contact.billing_contact} TVA"
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
end
