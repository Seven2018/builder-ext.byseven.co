class TheoryContentsController < ApplicationController
  def create
    @content = Content.find(params[:content_id])
    @theory = Theory.find(params[:theory_content][:theory].to_s)
    @theory_content = TheoryContent.new(content: @content, theory: @theory)
    skip_authorization
    unless @content.theories.include?(@theory)
      if @theory_content.save
        redirect_back(fallback_location: root_path)
      else
        raise
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @content = Content.find(params[:content_id])
    @theory = Theory.find(params[:theory_content][:theory].to_s)
    @theory_content = TheoryContent.where(content: @content).where(theory: @theory)
    skip_authorization
    @theory_content.first.destroy
    redirect_back(fallback_location: root_path)
  end
end
