# frozen_string_literal: true

module Posts
  class CommentsController < Posts::BasePostsController
    def create
      @comment = @post.comments.create(comment_params)

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/create' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end

    def destroy
      @comment = Comment.find_by(id: params[:id])
      @comment.destroy

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/destroy' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end

    def edit
      @comment = Comment.find_by(id: params[:id])

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/edit' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end

    def cancel
      @comment = Comment.find_by(id: params[:id])

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/update' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end


    def update
      @comment = Comment.find_by(id: params[:id])
      @comment.update!(comment_params)

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/update' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:content).merge({ user_id: current_user.id })
    end
  end
end
