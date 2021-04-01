class ActionsController < ApplicationController
  before_action :set_action, only: [:show, :edit, :update, :destroy]

  # Index with "search" option
  def index
    params[:search] ? @actions = policy_scope(Action).where("lower(name) LIKE ?", "%#{params[:search][:name].downcase}%").order(name: :asc) : @actions = policy_scope(Action).order(name: :asc)
  end

  def show
    authorize @action
  end

  def new
    @action = Action.new
    authorize @action
  end

  def create
    @action = Action.new(action_params)
    @intelligences = Intelligence.all
    authorize @action
    @action.save ? (redirect_to action_path(@action)) : (render :new)
  end

  def edit
    authorize @action
  end

  def update
    authorize @action
    @action.update(action_params)
    @action.save ? (redirect_to action_path(@action)) : (render '_edit')
  end

  def destroy
    @action.destroy
    authorize @action
    redirect_to actions_path
  end

  private

  def set_action
    @action = Action.find(params[:id])
  end

  def action_params
    params.require(:act).permit(:name, :description, :intelligence1_id, :intelligence2_id)
  end
end
