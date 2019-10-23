class RequestsController < ApplicationController
  def create
    @request = Request.new(user_id: current_user.id, merchandise_id: params[:merchandise])
    authorize @request
    if @request.save
      redirect_to merchandise_path(Merchandise.find(params[:merchandise]))
    else
      raise
    end
  end

  def destroy
    @request = Request.find(params[:id])
    authorize @request
    @request.destroy
    redirect_to merchandise_path(Merchandise.find(params[:merchandise]))
  end
end
