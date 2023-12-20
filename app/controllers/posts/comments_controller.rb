# frozen_string_literal: true

module Posts
  class CommentsController < Posts::BasePostsController
    def create
      @comment = @post.comments.create(comment_params)

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/create' }
        format.html { render 'groups/sections/posts/show' }
      end
    end

    def destroy
      @comment = Comment.find_by(id: params[:id])
      @comment.destroy

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/destroy' }
        format.html { render 'groups/sections/posts/show' }
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:content).merge({ user_id: current_user.id })
    end
  end
end
