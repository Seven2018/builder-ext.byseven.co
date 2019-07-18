class ContentModulesController < ApplicationController
  before_action :set_content_module, only: [:show, :edit, :update, :destroy, :move]

  def show
    authorize @content_module
  end

  def new
    @content = Content.find(params[:content_id])
    @content_module = ContentModule.new
    authorize @content_module
  end

  def create
    @content = Content.find(params[:content_id])
    @content_module = ContentModule.new(content_module_params)
    authorize @content_module
    @content_module.content = @content
    if @content_module.save
      update_duration
      redirect_to content_path(@content)
    else
      render :new
    end
  end

  def edit
    authorize @content_module
    @content = @content_module.content
  end

  def update
    authorize @content_module
    @content = @content_module.content
    @content_module.update(content_module_params)
    if @content_module.save
      update_duration
      redirect_to content_path(@content)
    else
      render :edit
    end
  end

  def destroy
    authorize @content_module
    @content = Content.find(params[:content_id])
    @content_module.destroy
    update_duration
    redirect_to content_path(@content)
  end

  def move
    authorize @content_module
    @content = @content_module.content
    if @content_module.insert_at(params[:position].to_i)
    else
      raise
    end
  end

  private

  def set_content_module
    @content_module = ContentModule.find(params[:id])
  end

  def update_duration
    result = []
    @content.content_modules.each do |mod|
      result << mod.duration
    end
    @content.duration = result.sum
    @content.save
  end

  def content_module_params
    params.require(:content_module).permit(:title, :instructions, :duration, :url1, :url2, :image1, :image2, :logistics, :action1_id, :action2_id, :comments, :content_id)
  end
end
