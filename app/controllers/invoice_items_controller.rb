class InvoiceItemsController < ApplicationController
  before_action :set_invoice_item, only: [:show, :edit, :update, :destroy]

  def index
    @invoice_items = policy_scope(InvoiceItem)
    if params[:client_company_id].nil?
      @invoice_items = InvoiceItem.all
    else
      @invoice_items = InvoiceItem.where(client_company_id: params[:client_company_id].to_i)
    end
  end

  def show
    authorize @invoice_item
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@invoice_item.uuid}",
          layout: 'pdf.html.erb',
          :margin => { :bottom => 55 },
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

  def new_invoice
    @training = Training.find(params[:training_id])
    @client_company = ClientCompany.find(params[:client_company_id])
    @invoice = InvoiceItem.new(training_id: params[:training_id].to_i, client_company_id: params[:client_company_id].to_i,
                           status: 'Non payée', issue_date: Date.today, due_date: Date.today + 1.months, type: 'Invoice')
    authorize @invoice
    if Invoice.all.empty?
      @invoice.uuid = "FA#{Date.today.strftime('%Y%m%d')}-1"
    else
      @invoice.uuid = "FA#{Date.today.strftime('%Y%m%d')}-#{Invoice.last.id + 1}"
    end
    if @invoice.save
      redirect_to invoice_items_path
    end
  end

  private

  def set_invoice_item
    @invoice_item = InvoiceItem.find(params[:id])
  end
end
