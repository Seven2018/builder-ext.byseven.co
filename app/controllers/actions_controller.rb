class ActionsController < ApplicationController
  before_action :set_action, only: [:show, :edit, :update, :destroy]

  def index
    @actions = policy_scope(Action).order(name: :asc)
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
    if @action.save
      redirect_to action_path(@action)
    else
      render :new
    end
  end

  def edit
    authorize @action
  end

  def update
    authorize @action
    @action.update(action_params)
    if @action.save
      redirect_to action_path(@action)
    else
      render '_edit'
    end
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
    params.require(:act).permit(:name, :description, :intelligence_id)
  end
end
