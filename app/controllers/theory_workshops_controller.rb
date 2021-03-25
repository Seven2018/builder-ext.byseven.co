class TheoryWorkshopsController < ApplicationController
  def create
    @workshop = Workshop.find(params[:workshop_id])
    @theory = Theory.find(params[:theory_workshop][:theory].to_s)
    @theory_workshop = TheoryWorkshop.new(workshop: @workshop, theory: @theory)
    skip_authorization
    unless @workshop.theories.include?(@theory)
      if @theory_workshop.save
        redirect_back(fallback_location: root_path)
      else
        raise
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @workshop = Workshop.find(params[:workshop_id])
    @theory = Theory.find(params[:theory_workshop][:theory].to_s)
    @theory_workshop = TheoryWorkshop.where(workshop: @workshop).where(theory: @theory)
    skip_authorization
    @theory_workshop.first.destroy
    redirect_back(fallback_location: root_path)
  end
end
