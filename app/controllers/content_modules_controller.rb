class ContentModulesController < ApplicationController
  before_action :set_content_module, only: [:show, :edit, :update, :destroy, :move_up, :move_down]
  before_action :set_content, only: [:new, :create]

  def show
    authorize @content_module
  end

  def new
    @content_module = ContentModule.new
    authorize @content_module
  end

  def create
    @content_module = ContentModule.new(content_module_params)
    authorize @content_module
    @content_module.content = @content
    @content_module.position = @content.content_modules.count + 1
    @content_module.duration = params[:content_module][:duration][1].split(' ')[0].to_i
    @content_module.action1_id = params[:content_module][:action1_id][0].to_i
    @content_module.action2_id = params[:content_module][:action1_id][1].to_i
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
    @content_module.update(duration: params[:content_module][:duration][1].split(' ')[0].to_i, action1_id: params[:content_module][:action1_id][0].to_i, action2_id: params[:content_module][:action1_id][1].to_i)
    if @content_module.save
      update_duration
      redirect_to content_path(@content)
    else
      render :edit
    end
  end

  def destroy
    authorize @content_module
    @content = @content_module.content
    @content_module.destroy
    position = 1
    @content.content_modules.order(position: :asc).each do |mod|
      mod.update(position: position)
      position += 1
    end
    update_duration
    redirect_to content_path(@content)
  end

  # Allows the ordering of modules (position)
  def move_up
    authorize @content_module
    @content = @content_module.content
    unless @content_module.position == 1
      previous_module = @content.content_modules.where(position: @content_module.position - 1).first
      previous_module.update(position: @content_module.position)
      @content_module.update(position: (@content_module.position - 1))
    end
    @content_module.save
    respond_to do |format|
      format.html {redirect_to content_path(@content)}
      format.js
    end
  end

  # Allows the ordering of modules (position)
  def move_down
    authorize @content_module
    @content = @content_module.content
    unless @content_module.position == @content.content_modules.count
      next_module = @content.content_modules.where(position: @content_module.position + 1).first
      next_module.update(position: @content_module.position)
      @content_module.update(position: (@content_module.position + 1))
    end
    @content_module.save
    respond_to do |format|
      format.html {redirect_to content_path(@content)}
      format.js
    end
  end

  private

  def set_content
    @content = Content.find(params[:content_id])
  end

  def set_content_module
    @content_module = ContentModule.find(params[:id])
  end

  # Updates Content duration as sum of ContentModules durations
  def update_duration
    result = []
    @content.content_modules.each do |mod|
      result << mod.duration
    end
    @content.duration = result.sum
    @content.save
  end

  def content_module_params
    params.require(:content_module).permit(:title, :instructions, :logistics, :comments, :content_id)
  end
end
