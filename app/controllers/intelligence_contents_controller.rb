class IntelligenceContentsController < ApplicationController
  def create
    @content = Content.find(params[:content_id])
    @intelligence = Intelligence.find(params[:intelligence_id])
    @intel_content = IntelligenceContent.new(content: @content, intelligence: @intelligence)
    authorize @intel_content
    if @intel_content.save
      redirect_to content_path(@content)
    else
      raise
  end
end
