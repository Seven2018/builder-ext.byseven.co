class InvoiceItemsController < ApplicationController
  before_action :set_invoice_item, only: [:show, :edit, :marked_as_paid, :upload_to_sheet, :destroy]

  # Indexes with a filter option (see below)
  def index
    @invoice_items = policy_scope(InvoiceItem)
    index_filtered
  end

  # Shows an InvoiceItem in html or pdf version
  def show
    authorize @invoice_item
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@invoice_item.uuid}",
          layout: 'pdf.html.erb',
          margin: { bottom: 55, top: 62 },
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
    @invoice_items_grid = InvoiceItemsGrid.new(params[:invoice_items_grid])
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
    @invoice.type == 'Invoice' ? @invoice.uuid = "FA#{Date.today.strftime('%Y')}%05d" % (Invoice.count+1) : @invoice.uuid = "DE#{Date.today.strftime('%Y')}%05d" % (Estimate.count+1)
    @invoice.type == 'Invoice' ? @invoice.status = 'Non payée' : @invoice.status = 'En attente'
    # Fills the created InvoiceItem with InvoiceLines, according Training data
    if @training.client_contact.client_company.client_company_type == 'Entreprise'
      product = Product.find(2)
      quantity = 0
      @training.sessions.each do |session|
        session.duration < 4 ? quantity += 0.5 * session.session_trainers.count : quantity += 1 * session.session_trainers.count
      end
      InvoiceLine.create(invoice_item: @invoice, description: product.name, quantity: quantity, net_amount: product.price, tax_amount: product.tax, product_id: product.id, position: 1)
    else
      product = Product.find(1)
      quantity = 0
      @training.sessions.each do |session|
      quantity += session.duration
      end
      InvoiceLine.create(invoice_item: @invoice, description: product.name, quantity: quantity, net_amount: product.price, tax_amount: product.tax, product_id: product.id, position: 1)
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

  # Marks an InvoiceItem as paid
  def marked_as_paid
    authorize @invoice_item
    index_filtered
    @invoice_item.type == 'Invoice' ? @invoice_item.update(status: 'Payée') : @invoice_item.update(status: 'Accepté')
    respond_to do |format|
      format.html {redirect_to invoice_items_path(type: @invoice_item.type)}
      format.js
    end
  end

  # Uploads to a GoogleSheet (not used)
  # def upload_to_sheet
  #   authorize @invoice_item
  #   @training = @invoice_item.training
  #   session = GoogleDrive::Session.from_service_account_key("client_secret.json")
  #   spreadsheet = session.spreadsheet_by_title("Copie de Seven Numbers #{@invoice_item.issue_date.strftime('%Y')}")
  #   worksheet = spreadsheet.worksheets.first
  #   preparation = 0
  #   costs = 0
  #   deposit = 0
  #   @invoice_item.invoice_lines.each do |line|
  #     if line.product.product_type == 'Préparation'
  #       preparation += line.quantity * line.net_amount
  #     elsif
  #       line.product.product_type == 'Frais'
  #       costs += line.quantity * line.net_amount
  #     elsif
  #       line.product.product_type == 'Caution'
  #       deposit += line.quantity * line.net_amount
  #     end
  #   end
  #   @invoice_item.training.client_contact.client_company.client_company_type == 'Entreprise' ? unit = 'j' : unit = 'h'
  #   worksheet.delete_rows((Invoice.count+1), 1)
  #   worksheet.insert_rows((Invoice.count+1), [[@training.start_date.strftime('%d/%m/%y'), @training.end_date.strftime('%d/%m/%y'), @training.client_contact.client_company.name, @training.title, invoice_item_url(@invoice_item), @invoice_item.invoice_lines.first.quantity, unit, @invoice_item.invoice_lines.first.net_amount.round, (@invoice_item.invoice_lines.first.net_amount*@invoice_item.invoice_lines.first.quantity).round, preparation, deposit, @invoice_item.tax_amount.round, costs, '', (@invoice_item.total_amount - @invoice_item.tax_amount).round, @invoice_item.uuid, @invoice_item.issue_date.strftime('%d/%m/%y')]])
  #   worksheet.save
  #   redirect_to invoice_item_path(@invoice_item)
  #   flash[:notice] = "Uploadé avec succès"
  # end

  private

  # Filter for index method
  def index_filtered
    if params[:training_id]
      @invoice_items = InvoiceItem.where(training_id: params[:training_id].to_i)
    elsif params[:client_company_id].nil?
      @invoice_items = InvoiceItem.all.order('id DESC')
    elsif params[:type] == 'Invoice'
      @invoice_items = Invoice.where(client_company_id: params[:client_company_id].to_i).order('id DESC')
    elsif params[:type] == 'Estimate'
      @invoice_items = Estimate.where(client_company_id: params[:client_company_id].to_i).order('id DESC')
    end
    return @invoice_items
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
end
