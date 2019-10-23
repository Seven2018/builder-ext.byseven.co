class MerchandisesController < ApplicationController
  before_action :set_merchandise, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search]
      @merchandises = policy_scope(Merchandise).where("lower(name) LIKE ?", "%#{params[:search][:name].downcase}%").order(name: :asc)
    else
      @merchandises = policy_scope(Merchandise)
    end
  end

  def show
    authorize @merchandise
  end

  def new
    @merchandise = Merchandise.new
    authorize @merchandise
  end

  def create
    @merchandise = Merchandise.new(merchandise_params)
    authorize @merchandise
    if @merchandise.save
      redirect_to merchandise_path(@merchandise)
    else
      raise
    end
  end

  def edit
    authorize @merchandise
  end

  def update
    authorize @merchandise
    @merchandise.update(merchandise_params)
    if @merchandise.save
      redirect_to merchandise_path(@merchandise)
    else
      raise
    end
  end

  def destroy
    authorize @merchandise
    @merchandise.destroy
    redirect_to merchandises_path
  end

  private

  def set_merchandise
    @merchandise = Merchandise.find(params[:id])
  end

  def merchandise_params
    params.require(:merchandise).permit(:name, :description, :theme_id)
  end
end
