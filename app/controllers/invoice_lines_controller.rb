class InvoiceLinesController < ApplicationController
  before_action :set_line, only: [:edit, :update, :destroy]

  def create
    @invoice_item = InvoiceItem.find(params[:invoice_item_id])
    @product = Product.find(params[:product_id])
    @invoiceline = InvoiceLine.new(invoice_item_id: @invoice_item.id, description: @product.name, quantity: 1, net_amount: @product.price, tax_amount: @product.tax)
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
    params.require(:invoice_line).permit(:description, :quantity)
  end
end
