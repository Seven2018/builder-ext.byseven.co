class WorkshopModulesController < ApplicationController
before_action :set_workshop_module, only: [:show, :edit, :update, :destroy, :move_up, :move_down, :viewer]

  def show
    authorize @workshop_module
  end

  def new
    @workshop = Workshop.find(params[:workshop_id])
    @workshop_module = WorkshopModule.new
    authorize @workshop_module
  end

  def create
    @workshop = Workshop.find(params[:workshop_id])
    @workshop_module = WorkshopModule.new(workshop_module_params)
    authorize @workshop_module
    @workshop_module.workshop = @workshop
    if @workshop_module.save
      update_duration
      redirect_to training_session_workshop_path(@workshop.session.training, @workshop.session, @workshop)
    else
      render :new
    end
  end

  def edit
    authorize @workshop_module
    @workshop = @workshop_module.workshop
  end

  def update
    authorize @workshop_module
    @workshop = @workshop_module.workshop
    @workshop_module.update(workshop_module_params)
    if @workshop_module.save
      update_duration
      redirect_to training_session_workshop_path(@workshop.session.training, @workshop.session, @workshop)
    else
      render :edit
    end
  end

  def destroy
    authorize @workshop_module
    @workshop = @workshop_module.workshop
    @workshop_module.destroy
    update_duration
    redirect_to training_session_workshop_path(@workshop.session.training, @workshop.session, @workshop)
  end

  def move_up
    authorize @workshop_module
    @workshop = @workshop_module.workshop
    array = []
    @workshop.workshop_modules.order('position ASC').each do |mod|
      array << mod
    end
    unless @workshop_module.position == 1
      array.insert((@workshop_module.position - 2), array.delete_at(@workshop_module.position - 1))
    end
    array.compact.each do |mod|
      mod.update(position: array.index(mod) + 1)
    end
    @workshop_module.save
    respond_to do |format|
      format.html {redirect_to training_session_workshop_path(@workshop.session.training, @workshop.session, @workshop)}
      format.js
    end
  end

  def move_down
    authorize @workshop_module
    @workshop = @workshop_module.workshop
    array = []
    @workshop.workshop_modules.order('position ASC').each do |mod|
      array << mod
    end
    unless @workshop_module.position == array.compact.count
      array.insert((@workshop_module.position), array.delete_at(@workshop_module.position - 1))
    end
    array.compact.each do |mod|
      mod.update(position: array.index(mod) + 1)
    end
    @workshop_module.save
    respond_to do |format|
      format.html {redirect_to training_session_workshop_path(@workshop.session.training, @workshop.session, @workshop)}
      format.js
    end
  end

  def viewer
    authorize @workshop_module
  end

 private

  def set_workshop_module
    @workshop_module = WorkshopModule.find(params[:id])
  end

  def update_duration
    result = []
    @workshop.workshop_modules.each do |mod|
      result << mod.duration
    end
    @workshop.duration = result.sum
    @workshop.save
  end

  def workshop_module_params
    params.require(:workshop_module).permit(:title, :instructions, :duration, :url1, :url2, :image1, :image2, :logistics, :action1_id, :action2_id, :comments, :workshop_id)
  end
end
