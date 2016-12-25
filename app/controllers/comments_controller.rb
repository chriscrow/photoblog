class CommentsController < ApplicationController
  before_action :already_signed_in_user, only: [:create]

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
    
    def already_signed_in_user
      if current_user != nil
        params[:comment][:commenter] = current_user.nickname
      end
    end
end
