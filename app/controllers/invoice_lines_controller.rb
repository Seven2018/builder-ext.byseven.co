class InvoiceLinesController < ApplicationController
  before_action :set_line, only: [:edit, :update, :destroy, :move_up, :move_down]

  def create
    @invoice_item = InvoiceItem.find(params[:invoice_item_id])
    @product = Product.find(params[:product_id]) if params[:product_id]
    if @product
      @invoiceline = InvoiceLine.new(invoice_item_id: @invoice_item.id, product_id: @product.id, description: @product.name, quantity: 1, net_amount: @product.price, tax_amount: @product.tax, position: @invoice_item.invoice_lines.count + 1)
    else
      @invoiceline = InvoiceLine.new(invoice_item_id: @invoice_item.id, description: 'Commentaires', position: @invoice_item.invoice_lines.count + 1)
    end
    authorize @invoiceline
    if @invoiceline.save
      redirect_to invoice_item_path(@invoice_item)
    else
      raise
    end
  end

  def edit
    authorize @invoiceline
  end

  def update
    authorize @invoiceline
    @invoiceline.update(invoiceline_params)
    if @invoiceline.save
      redirect_to invoice_item_path(@invoiceline.invoice_item)
    end
  end

  def destroy
    authorize @invoiceline
    @invoiceline.destroy
    redirect_to invoice_item_path(@invoiceline.invoice_item)
  end

  def move_up
    authorize @invoiceline
    @invoiceitem = @invoiceline.invoice_item
    array = []
    @invoiceitem.invoice_lines.order('position ASC').each do |line|
      array << line
    end
    unless @invoiceline.position == 1
      array.insert((@invoiceline.position - 2), array.delete_at(@invoiceline.position - 1))
    end
    array.compact.each do |line|
      line.update(position: array.index(line) + 1)
    end
    @invoiceline.save
    respond_to do |format|
      format.html {redirect_to invoice_item_path(@invoiceitem)}
      format.js
    end
  end

  def move_down
    authorize @invoiceline
    @invoiceitem = @invoiceline.invoice_item
    array = []
    @invoiceitem.invoice_lines.order('position ASC').each do |line|
      array << line
    end
    unless @invoiceline.position == array.compact.count
      array.insert((@invoiceline.position), array.delete_at(@invoiceline.position - 1))
    end
    array.compact.each do |line|
      line.update(position: array.index(line) + 1)
    end
    @invoiceline.save
    respond_to do |format|
      format.html {redirect_to invoice_item_path(@invoiceitem)}
      format.js
    end
  end

  private

  def set_line
    @invoiceline = InvoiceLine.find(params[:id])
  end

  # def update_price
  #   price = @product.price * @invoiceline.quantity
  #   @invoiceline.update(net_amount: price, tax_amount: price * @product.tax / 100)
  #   @invoiceline.save
  # end

  def invoiceline_params
    params.require(:invoice_line).permit(:description, :quantity, :net_amount, :comments)
  end
end
