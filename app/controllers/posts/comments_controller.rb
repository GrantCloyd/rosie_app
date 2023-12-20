# frozen_string_literal: true

module Posts
  class CommentsController < Posts::BasePostsController

    def create
      @comment = @post.comments.create(comment_params)

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/create' }
        format.html { render 'groups/sections/posts' }
      end
    end
      
    private

    def comment_params
      params.require(:comment).permit(:content).merge({user_id: current_user.id})
    end

  end
end
