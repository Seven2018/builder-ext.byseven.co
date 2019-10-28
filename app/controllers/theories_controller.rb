class TheoriesController < ApplicationController
  before_action :set_theory, only: [:show, :edit, :update, :destroy]

  # Index with "search" option
  def index
    if params[:search]
      @theories = policy_scope(Theory).where("lower(name) LIKE ?", "%#{params[:search][:name].downcase}%").order(name: :asc)
    else
      @theories = policy_scope(Theory).order(name: :asc)
    end
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
    @theory.save ? (redirect_to theories_path) : (render :new)
  end

  def edit
    authorize @theory
  end

  def update
    authorize @theory
    @theory.update(theory_params)
    @theory.save ? (redirect_to theory_path(@theory)) : (render :edit)
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
