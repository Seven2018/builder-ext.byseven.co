class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  def index
    @contents = Content.all
    @contents = policy_scope(Content)
    @themes = Theme.all
  end

  def show
    authorize @content
  end

  def new
    @content = Content.new
    authorize @content
  end

  def create
    @content = Content.new(content_params)
    authorize @content
    if @content.save
      redirect_to content_path(@content)
    else
      render :new
    end
  end

  def edit
    authorize @content
  end

  def update
    authorize @content
    @content.update(content_params)
    if @content.save
      redirect_to content_path(@content)
    else
      render "_edit"
    end
  end

  def destroy
    @content.destroy
    authorize @content
    redirect_to contents_path
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:title, :duration, :description, :theme_id)
  end
end
