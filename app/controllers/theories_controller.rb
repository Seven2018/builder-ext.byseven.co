class TheoriesController < ApplicationController
  before_action :set_theory, only: [:show, :edit, :update, :destroy]

  def index
    @theories = policy_scope(Theory).order(name: :asc)
  end

  def show
    authorize @theory
  end

  def new
    @theory = Theory.new
    authorize @theory
  end

  def create
    @theory = Theory.new(theory_params)
    authorize @theory
    if @theory.save
      redirect_to theories_path
    else
      render :new
    end
  end

  def edit
    authorize @theory
  end

  def update
    authorize @theory
    @theory.update(theory_params)
    if @theory.save
      redirect_to theory_path(@theory)
    else
      render :edit
    end
  end

  def destroy
    authorize @theory
    @theory.destroy
    redirect_to theories_path
  end

  private

  def set_theory
    @theory = Theory.find(params[:id])
  end

  def theory_params
    params.require(:theory).permit(:name, :description, :links, :references)
  end
end
