class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    authorize @comment
    @comment.session = Session.find(params[:session_id])
    @comment.user = current_user
    if @comment.save
      redirect_to project_session_path(@comment.session.project, @comment.session)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to project_session_path(@comment.session.project, @comment.session)
  end

  private

  def comment_params
    params.require(:comment).permit(:object, :content, :user_id, :session_id)
  end
end
