class InvoiceItemsController < ApplicationController
  before_action :set_invoice_item, only: [:show, :edit, :copy, :copy_here, :edit_client, :credit, :marked_as_send, :marked_as_paid, :marked_as_reminded, :destroy]

  # Indexes with a filter option (see below)
  def index
    @invoice_items = policy_scope(InvoiceItem)
    index_filtered
    @invoice_items = InvoiceItem.where(created_at: params[:export][:start_date]..params[:export][:end_date]).order(:uuid) if params[:export].present?
    respond_to do |format|
      format.html
      format.csv { send_data @invoice_items.to_csv, filename: "Facture SEVEN #{params[:export][:start_date].split('-').join('')} - #{params[:export][:end_date].split('-').join('')}" }
    end
  end

  # Shows an InvoiceItem in html or pdf version
  def show
    authorize @invoice_item
    if @invoice_item.invoice_lines.where(description: 'Nom').present?
      uuid = @invoice_item.uuid + ' - ' + @invoice_item.invoice_lines.where(description: 'Nom').first.comments.split('>')[1].split('<')[0]
    else
      uuid = @invoice_item.uuid
    end
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{uuid}",
          layout: 'pdf.html.erb',
          margin: { bottom: 45, top: 62 },
          header: { margin: { top: 0, bottom: 0 }, html: { template: 'invoice_items/header.pdf.erb' } },
          footer: { margin: { top: 0, bottom: 0 }, html: { template: 'invoice_items/footer.pdf.erb' } },
          template: 'invoice_items/show',
          background: true,
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 300,
          zoom: 1
        )
      end
    end
  end

  def edit
    authorize @invoice_item
  end

  def update
    authorize @invoice_item
    @invoice_item.update(invoiceitem_params)
    if @invoice_item.save
      redirect_to invoice_item_path(@invoice_item)
    end
  end

  # Creates a chart (Numbers) of InvoicesItems, for reporting purposes (gem)
  def report
    @invoice_items = InvoiceItem.all
    # @invoice_items_grid = InvoiceItemsGrid.new(params[:invoice_items_grid])
    authorize @invoice_items
    respond_to do |format|
      format.html
      format.csv { send_data @invoice_items_grid.to_csv }
    end
  end

  # Creates a new InvoiceItem, proposing a pre-filled version to be edited if necessary
  def new_invoice_item
    @training = Training.find(params[:training_id])
    @client_company = ClientCompany.find(params[:client_company_id])
    @invoice = InvoiceItem.new(training_id: params[:training_id].to_i, client_company_id: params[:client_company_id].to_i, type: params[:type])
    authorize @invoice
    # ttributes a invoice number to the InvoiceItem
    @invoice.type == 'Invoice' ? @invoice.uuid = "FA#{Date.today.strftime('%Y')}%05d" % (Invoice.where(type: 'Invoice').count+715) : @invoice.uuid = "DE#{Date.today.strftime('%Y')}%05d" % (Invoice.where(type: 'Estimate').count+1)
    @invoice.status = 'En attente'
      # @invoice.type == 'Invoice' ? @invoice.status = 'Non payée' : @invoice.status = 'En attente'
    # Fills the created InvoiceItem with InvoiceLines, according Training data
    if @training.client_contact.client_company.client_company_type == 'Company'
      product = Product.find(2)
      quantity = 0
      @training.sessions.each do |session|
        session.duration < 4 ? quantity += 0.5 * session.session_trainers.count : quantity += 1 * session.session_trainers.count
      end
      InvoiceLine.create(invoice_item: @invoice, description: @training.title, quantity: quantity, net_amount: product.price, tax_amount: product.tax, product_id: product.id, position: 1)
    else
      product = Product.find(1)
      quantity = 0
      @training.sessions.each do |session|
      quantity += session.duration
      end
      InvoiceLine.create(invoice_item: @invoice, description: @training.title, quantity: quantity, net_amount: product.price, tax_amount: product.tax, product_id: product.id, position: 1)
    end
    update_price(@invoice)
    if @invoice.save
      redirect_to invoice_item_path(@invoice)
    end
  end

  # Creates a new InvoiceItem (Sevener PoV), proposing a pre-filled version to be edited if necessary
  def new_sevener_invoice
    @training = Training.find(params[:training_id])
    @client_company = ClientCompany.find(params[:client_company_id])
    @sevener_invoice = InvoiceItem.new(training_id: params[:training_id].to_i, client_company_id: params[:client_company_id].to_i, issue_date: Date.today, due_date: Date.today + 1.months, user_id: current_user.id, type: 'InvoiceSevener')
    authorize @sevener_invoice
    # Attributes a invoice number to the InvoiceItem
    @sevener_invoice.uuid = "#{current_user.firstname[0]}#{current_user.lastname[0]}#{Date.today.strftime('%Y')}%05d" % (InvoiceSevener.where(user_id: current_user.id).count+1)
    # Fills the created InvoiceItem with InvoiceLines, according Training data
    if @training.client_contact.client_company.client_company_type == 'Entreprise'
      product = Product.find(10)
      quantity = 0
      @training.sessions.each do |session|
        session.duration < 4 ? quantity += 0.5 : quantity += 1
      end
      InvoiceLine.create(invoice_item: @sevener_invoice, description: product.name, quantity: quantity, net_amount: product.price, tax_amount: product.tax, position: 1)
    else
      product = Product.find(11)
      quantity = 0
      @training.sessions.each do |session|
        quantity += session.duration
      end
      InvoiceLine.create(invoice_item: @sevener_invoice, description: product.name, quantity: quantity, net_amount: product.price, tax_amount: product.tax, position: 1)
    end
    update_price(@sevener_invoice)
    redirect_to invoice_item_path(@sevener_invoice) if @sevener_invoice.save
  end


  def new_estimate
    @client_company = ClientCompany.find(params[:client_company_id])
    @estimate = InvoiceItem.new(client_company_id: params[:client_company_id].to_i, type: 'Estimate')
    authorize @estimate
    Estimate.all.count != 0 ? (@estimate.uuid = "DE#{Date.today.strftime('%Y')}" + (Estimate.last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (@estimate.uuid = "DE#{Date.today.strftime('%Y')}00001")
    if @estimate.save
      if @client_company.client_company_type == 'Company'
        product = Product.find(2)
        InvoiceLine.create(invoice_item: @estimate, description: product.name, quantity: 0, net_amount: product.price, tax_amount: product.tax, position: 1)
      elsif @client_company.client_company_type == 'School'
        product = Product.find(1)
        quantity = 0
        InvoiceLine.create(invoice_item: @estimate, description: product.name, quantity: 0, net_amount: product.price, tax_amount: product.tax, position: 1)
    end
      redirect_to invoice_item_path(@estimate)
    end
  end

  # Allows the duplication of an InvoiceItem
  def copy
    authorize @invoice_item
    @training = Training.find(params[:copy][:training_id])
    new_invoice_item = InvoiceItem.new(@invoice_item.attributes.except("id", "created_at", "updated_at", "training_id", "client_company_id", "status", "sending_date", "payment_date", "dunning_date"))
    if @invoice_item.type == 'Invoice'
      new_invoice_item.uuid = "FA#{Date.today.strftime('%Y')}%05d" % (Invoice.where(type: 'Invoice').count+716)
    else
      new_invoice_item.uuid = "DE#{Date.today.strftime('%Y')}%05d" % (Invoice.where(type: 'Estimate').count+1)
    end
    new_invoice_item.training_id = @training.id
    new_invoice_item.client_company_id = @training.client_company.id
    new_invoice_item.status = 'En attente'
    if new_invoice_item.save
      @invoice_item.invoice_lines.each do |line|
        new_invoice_line = InvoiceLine.create(line.attributes.except("id", "created_at", "updated_at", "invoice_item_id"))
        new_invoice_line.update(invoice_item_id: new_invoice_item.id)
      end
      redirect_to invoice_item_path(new_invoice_item)
    else
      raise
    end
  end

  def copy_here
    authorize @invoice_item
    new_invoice_item = InvoiceItem.new(@invoice_item.attributes.except("id", "created_at", "updated_at", "sending_date", "payment_date", "dunning_date"))
    if @invoice_item.type == 'Invoice'
      new_invoice_item.uuid = "FA#{Date.today.strftime('%Y')}%05d" % (Invoice.where(type: 'Invoice').count+716)
    else
      new_invoice_item.uuid = "DE#{Date.today.strftime('%Y')}%05d" % (Invoice.where(type: 'Estimate').count+1)
    end
    new_invoice_item.status = 'En attente'
    if new_invoice_item.save
      @invoice_item.invoice_lines.each do |line|
        new_invoice_line = InvoiceLine.create(line.attributes.except("id", "created_at", "updated_at", "invoice_item_id"))
        new_invoice_line.update(invoice_item_id: new_invoice_item.id)
      end
      redirect_to invoice_item_path(new_invoice_item)
    else
      raise
    end
  end

  # Allows to change the ClientCompany of an InvoiceItem (OPCO cases)
  def edit_client
    authorize @invoice_item
    company = ClientCompany.find(params[:client_company_id])
    if company.client_company_type == 'Company'
      @invoice_item.update(client_company_id: company.opco_id, description: "#{company.id}")
    elsif company.client_company_type == 'OPCO'
      @invoice_item.update(client_company_id: @invoice_item.description.to_i, description: nil)
    end
    redirect_to invoice_item_path(@invoice_item)
  end

  # Creates a credit
  def credit
    authorize @invoice_item
    credit = InvoiceItem.new(@invoice_item.attributes.except("id", "created_at", "updated_at"))
    credit.uuid = "FA#{Date.today.strftime('%Y')}%05d" % (Invoice.where(type: 'Invoice').count + 715)
    if credit.save
      @invoice_item.invoice_lines.each do |line|
        new_invoice_line = InvoiceLine.create(line.attributes.except("id", "created_at", "updated_at", "invoice_item_id"))
        new_invoice_line.update(invoice_item_id: credit.id)
        new_invoice_line.update(net_amount: -(line.net_amount)) if line.net_amount.present?
      end
      redirect_to invoice_item_path(credit)
    else
      raise
    end
  end

  # Marks an InvoiceItem as send
  def marked_as_send
    authorize @invoice_item
    index_filtered
    @invoice_item.update(sending_date: params[:edit_sending][:sending_date])
    redirect_back(fallback_location: invoice_item_path(@invoice_item))
  end

  # Marks an InvoiceItem as paid
  def marked_as_paid
    authorize @invoice_item
    index_filtered
    @invoice_item.update(payment_date: params[:edit_payment][:payment_date])
    respond_to do |format|
      format.html {redirect_to invoice_items_path(type: @invoice_item.type)}
      format.js
    end
  end

    # Marks an InvoiceItem as reminded
  def marked_as_reminded
    authorize @invoice_item
    index_filtered
    @invoice_item.update(dunning_date: params[:edit_payment][:dunning_date])
    respond_to do |format|
      format.html {redirect_to invoice_items_path(type: @invoice_item.type)}
      format.js
    end
  end

  # Uploads to a GoogleSheet (not used)
  def upload_to_sheet
    @invoice_items = InvoiceItem.where({ created_at: Time.current.beginning_of_year..Time.current.end_of_year }).order(:created_at)
    authorize @invoice_items
    # session = GoogleDrive::Session.from_service_account_key("client_secret.json")
    session = GoogleDrive::Session.from_config("client_secret.json")
    spreadsheet = session.spreadsheet_by_title("Copie de Seven Numbers #{Time.current.year}")
    worksheet = spreadsheet.worksheets.first
    row = 2
      @invoice_items.each do |item|
        startdate = item.training.sessions.order(date: :asc).first.date&.strftime('%d/%m/%y')
        enddate = item.training.sessions.order(date: :asc).last.date&.strftime('%d/%m/%y')
        client = item.client_company.name
        training_name = item.training.title
        trello = ''
        unit = 0
        unit_price = 0
        variable = 0
        fixed = 0
        caution = 0
        expenses = 0
        expenses_out = 0
        item.invoice_lines.each do |line|
          unit += line.quantity if ((line.product = Product.find(1) || line.product == Product.find(2) || line.product == Product.find(7) || line.product == Product.find(9)) && line.quantity.present?)
          unit_price += line.net_amount if ((line.product = Product.find(1) || line.product == Product.find(2)) && line.quantity.present? )
          variable += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present?)
          fixe += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Préparation')
          caution += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Caution')
          expenses += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Frais')
        end
        item.training.client_company.client_company_type == 'Company' ? nature = 'j' : nature = 'h'
        description = item.description
        vat = item.tax_amount
        revenue = item.total_amount
        num = item.uuid
        sending = item.sending_date&.strftime('%d/%m/%y') if item.sending_date.present?
        dunning = item.dunning_date&.strftime('%d/%m/%y') if item.dunning_date.present?
        payment = item.payment_date&.strftime('%d/%m/%y') if item.payment_date.present?
        worksheet.insert_rows(row, [[startdate, enddate, client, training_name, trello, unit, nature, unit_price, variable, fixed, caution, vat, expenses, expenses_out, description, revenue, num, sending, dunning, payment]])
        row += 1
        item.training.trainers.each do |trainer|
          if trainer.access_level == 'sevener'
            worksheet.insert_rows(row, [[startdate, enddate, client, training_name, trello, '0', '', '0', '', '', '', '', '', '', '', '0', '/', '/', '/', '/', '/', '/', "#{trainer.firstname} #{trainer.lastname}", '01/01/20', '','480', '01/01/20']])
            row += 1
          end
        end
      end
    # end
    # worksheet.delete_rows((Invoice.count+1), 1)
    worksheet.save
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Uploadé avec succès"
  end

  def destroy
    authorize @invoice_item
    @invoice_item.destroy
    redirect_to client_company_path(@invoice_item.client_company)
  end

  private

  # Filter for index method
  def index_filtered
    if params[:training_id].present?
      @invoice_items = InvoiceItem.where(training_id: params[:training_id].to_i)
    elsif params[:client_company_id].nil?
      @invoice_items = InvoiceItem.all.order('id DESC')
    elsif params[:type] == 'Invoice' && params[:client_company_id]
      @invoice_items = Invoice.where(client_company_id: params[:client_company_id].to_i).order('id DESC')
    elsif params[:type] == 'Estimate' && params[:client_company_id]
      @invoice_items = Estimate.where(client_company_id: params[:client_company_id].to_i).or(Estimate.where(description: params[:client_company_id])).order('id DESC')
    end
  end

  # Updates InvoiceItem price and tax amount
  def update_price(invoice)
    total = 0
    tax = 0
    invoice.invoice_lines.each do |line|
      total += line.quantity * line.net_amount * (1 + line.tax_amount/100)
      tax += line.quantity * line.net_amount * (line.tax_amount/100)
    end
    invoice.update(total_amount: total, tax_amount: tax)
    invoice.save
  end

  def set_invoice_item
    @invoice_item = InvoiceItem.find(params[:id])
  end

  def invoiceitem_params
    params.require(:invoice_item).permit(:status, :uuid)
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
