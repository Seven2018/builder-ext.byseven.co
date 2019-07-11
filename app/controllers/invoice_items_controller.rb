class InvoiceItemsController < ApplicationController
  before_action :set_invoice_item, only: [:show, :marked_as_paid, :destroy]

  def index
    @invoice_items = policy_scope(InvoiceItem)
    index_filtered
  end

  def show
    authorize @invoice_item
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@invoice_item.uuid}",
          layout: 'pdf.html.erb',
          :margin => { :bottom => 55, :top => 52 },
          :header => { :margin => { :top => 0, :bottom => 0 }, :html => { :template => 'invoice_items/header.pdf.erb' } },
          :footer => { :margin => { :top => 0, :bottom => 0 }, :html => { :template => 'invoice_items/footer.pdf.erb' } },
          template: 'invoice_items/show',
          background: true,
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 300,
          zoom: 1,
        )
      end
    end
  end

  def marked_as_paid
    authorize @invoice_item
    index_filtered
    @invoice_item.type == 'Invoice' ? @invoice_item.update(status: 'Payée') : @invoice_item.update(status: 'Accepté')
    respond_to do |format|
      format.html {redirect_to invoice_items_path(type: @invoice_item.type)}
      format.js
    end
  end

  def new_invoice_item
    @training = Training.find(params[:training_id])
    @client_company = ClientCompany.find(params[:client_company_id])
    @invoice = InvoiceItem.new(training_id: params[:training_id].to_i, client_company_id: params[:client_company_id].to_i, issue_date: Date.today, due_date: Date.today + 1.months, type: params[:type])
    authorize @invoice
    @invoice.type == 'Invoice' ? @invoice.uuid = "FA#{Date.today.strftime('%Y%m')}%05d" % (Invoice.count+1) : @invoice.uuid = "DE#{Date.today.strftime('%Y%m')}%05d" % (Estimate.count+1)
    @invoice.type == 'Invoice' ? @invoice.status = 'Non payée' : @invoice.status = 'En attente'
    if @training.client_contact.client_company.client_company_type == 'Entreprise'
      product = Product.find(2)
      quantity = 0
      @training.sessions.each do |session|
        session.duration < 4 ? quantity += 0.5 * session.session_trainers.count : quantity += 1 * session.session_trainers.count
      end
      InvoiceLine.create(invoice_item: @invoice, description: product.name, quantity: quantity, net_amount: product.price, tax_amount: product.tax)
    else
      product = Product.find(1)
      quantity = 0
      @training.sessions.each do |session|
        quantity += session.duration
      end
      InvoiceLine.create(invoice_item: @invoice, description: product.name, quantity: quantity, net_amount: product.price, tax_amount: product.tax)
    end
    update_price
    if @invoice.save
      redirect_to invoice_item_path(@invoice)
    end
  end

  private

  def index_filtered
    if params[:client_company_id].nil?
      @invoice_items = InvoiceItem.all.order('id DESC')
    elsif params[:type] == 'Invoice'
      @invoice_items = Invoice.where(client_company_id: params[:client_company_id].to_i).order('id DESC')
    elsif params[:type] == 'Estimate'
      @invoice_items = Estimate.where(client_company_id: params[:client_company_id].to_i).order('id DESC')
    end
    return @invoice_items
  end

  def update_price
    total = 0
    @invoice.invoice_lines.each do |line|
      total += line.quantity * line.net_amount * (1 + line.tax_amount/100)
    end
    @invoice.update(total_amount: total)
    @invoice.save
  end

  def set_invoice_item
    @invoice_item = InvoiceItem.find(params[:id])
  end

  def invoiceitem_params
    params.require(:invoice_item).permit(:status)
  end
end
