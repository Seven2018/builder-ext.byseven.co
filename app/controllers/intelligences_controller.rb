# Not used at the moment

# class IntelligencesController < ApplicationController
#   before_action :set_intelligence, only: [:show, :edit, :update, :destroy]

#   def index
#     @intelligences = policy_scope(Intelligence)
#   end

#   def show
#     authorize @intelligence
#   end

#   def new
#     @intelligence = Intelligence.new
#     authorize @intelligence
#   end

#   def create
#     @intelligence = Intelligence.new(intelligence_params)
#     authorize @intelligence
#     if @intelligence.save
#       redirect_to intelligence_path(@intelligence)
#     else
#       render :new
#     end
#   end

#   def edit
#     authorize @intelligence
#   end

#   def update
#     authorize @intelligence
#     @intelligence.update(intelligence_params)
#     if @intelligence.save
#       redirect_to intelligence_path(@intelligence)
#     else
#       render "_edit"
#     end
#   end

#   def destroy
#     @intelligence.destroy
#     authorize @intelligence
#     redirect_to intelligences_path
#   end

#   private

#   def set_intelligence
#     @intelligence = Intelligence.find(params[:id])
#   end

#   def intelligence_params
#     params.require(:intelligence).permit(:name, :description)
#   end
# end
