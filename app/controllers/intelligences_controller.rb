class IntelligencesController < ApplicationController
  before_action :set_intelligence, only: [:show, :edit, :update, :destroy]

  def index
    @intelligences = Intelligence.all
  end

  def show
  end

  def new
    @intelligence = Intelligence.new
  end

  def create
    @intelligence = Intelligence.new(intelligence_params)
    if @intelligence.save
      redirect_to intelligence_path(@intelligence)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @intelligence.update(intelligence_params)
    if @intelligence.save
      redirect_to intelligence_path(@intelligence)
    else
      render :edit
    end
  end

  def destroy
    @intelligence.destroy
    redirect_to intelligences_path
  end

  private

  def set_intelligence
    @intelligence = Intelligence.find(params[:id])
  end

  def intelligence_params
    params.require(:intelligence).permit(:name, :description)
  end
end
