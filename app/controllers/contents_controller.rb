class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  def index
    params[:search] ? @contents = policy_scope(Content).where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc) : @contents = policy_scope(Content).order(title: :asc)
    @contents = policy_scope(Content)
    @themes = Theme.all
  end

  def show
    authorize @content
    @theory_content = TheoryContent.new
  end

  def new
    @content = Content.new
    authorize @content
  end

  def create
    @content = Content.new(content_params)
    authorize @content
    @content.save ? (redirect_to content_path(@content)) : (render :new)
  end

  def edit
    authorize @content
  end

  def update
    authorize @content
    @content.update(content_params)
    @content.save ? (redirect_to content_path(@content)) : (render "_edit")
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
