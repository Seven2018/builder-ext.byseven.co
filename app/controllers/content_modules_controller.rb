class ContentModulesController < ApplicationController
  before_action :set_content_module, only: [:show, :edit, :update, :destroy, :move_up, :move_down]

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

  # Allows the ordering of modules (position)
  def move_up
    authorize @content_module
    @content = @content_module.content
    # Creates an array of ContentModules, ordered by position
    array = []
    @content.content_modules.order('position ASC').each do |mod|
      array << mod
    end
    # Moves a ContentModule in the array by switching indexes
    unless @content_module.position == 1
      array.insert((@content_module.position - 2), array.delete_at(@content_module.position - 1))
    end
    # Uses the array to update the ContentModules positions
    array.compact.each do |mod|
      mod.update(position: array.index(mod) + 1)
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
    # Creates an array of ContentModules, ordered by position
    array = []
    @content.content_modules.order('position ASC').each do |mod|
      array << mod
    end
    # Moves a ContentModule in the array by switching indexes
    unless @content_module.position == array.compact.count
      array.insert((@content_module.position), array.delete_at(@content_module.position - 1))
    end
    # Uses the array to update the ContentModules positions
    array.compact.each do |mod|
      mod.update(position: array.index(mod) + 1)
    end
    @content_module.save
    respond_to do |format|
      format.html {redirect_to content_path(@content)}
      format.js
    end
  end

  private

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
    params.require(:content_module).permit(:title, :instructions, :duration, :logistics, :action1_id, :action2_id, :comments, :content_id)
  end
end
