class InvoiceItem < ApplicationRecord
  belongs_to :client_company, optional: true
  belongs_to :training, optional: true
  belongs_to :user, optional: true
  has_many :invoice_lines, dependent: :destroy
  self.inheritance_column = :_type_disabled

  # def self.to_csv
  #   attributes = %w(Début Fin Nom_Client Nom_Formation Trello Unité Nature €/u CA_variable Ca_fixe Caution TVA Frais_facturés Frais_non_facturés Anc_Nouv CA_facturé Num_facture Emission Envoi Relance Paiement Intervenant Reception_Facture Montant Date_Paiement)
  #   CSV.generate(headers: true) do |csv|
  #     csv << attributes
  #     all.each do |item|
  #       startdate = item.training.start_date.strftime('%d/%m/%y')
  #       enddate = item.training.end_date.strftime('%d/%m/%y')
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
  #       sending = item.sending_date.strftime('%d/%m/%y') if item.sending_date.present?
  #       dunning = item.dunning_date.strftime('%d/%m/%y') if item.dunning_date.present?
  #       payment = item.payment_date.strftime('%d/%m/%y') if item.payment_date.present?
  #       csv << [startdate, enddate, client, training_name, trello, unit, nature, unit_price, variable, fixed, caution, vat, expenses, expenses_out, description, revenue, num, sending, dunning, payment]
  #       item.training.trainers.each do |trainer|
  #         csv << [startdate, enddate, client, training_name, trello, '', '', '', '', '', '', '', '', '', '', '', '', '', '', "","", "#{trainer.firstname} #{trainer.lastname}", '01/01/20', '480', '01/01/20']
  #       end
  #     end
  #   end
  # end

  def self.to_csv
    attributes = %w(Date Journal Compte_Général Compte_Auxiliaire Référence Libellé Débit Crédit Comptes_Produits)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |item|
        date = item.created_at.strftime('%d/%m/%Y')
        journal = 'VE'
        gen_account = '41100000'
        aux_account = item.client_company.reference
        invoice_num = item.uuid
        item.client_company.client_company_type = 'School' ? company_label = "#{item.client_company.name}" : company_label = "#{item.client_company.name} TVA"
        if item.total_amount > 0
          debit = item.total_amount
          credit = ''
        else
          debit = ''
          credit = -(item.total_amount)
        end
        products = ''
        item.invoice_lines.each do |line|
          if line.product&.reference.present?
            products += "#{line.product.reference} - #{line.net_amount}€\n"
          end
        end
        csv << [date, journal, gen_account, aux_account, invoice_num, company_label, debit, credit, products]
      end
    end
  end

  def gross_revenue
    self.total_amount - self.tax_amount
  end
end
