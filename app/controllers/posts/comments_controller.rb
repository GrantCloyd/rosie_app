# frozen_string_literal: true

module Posts
  class CommentsController < Posts::BasePostsController

    def index
      @comments = @post.comments
      render layout: false
    end

    def create
      @comment = @post.comments.new(comment_params)
      @comment.valid?

      if @comment.errors.present?
        respond_to do |format|
          render_turbo_flash_alert(format, format_errors(@comment))
          format.html { render :new }
        end
      else
        @comment.save!
        respond_to do |format|
          format.turbo_stream { render 'posts/comments/streams/create' }
          format.html { render template: 'groups/sections/posts/show' }
        end
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

    # TODO this should probably be moved to js it doesn't need to be a stream
    def cancel
      @comment = Comment.find_by(id: params[:id])

      respond_to do |format|
        format.turbo_stream { render 'posts/comments/streams/update' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end

    def update
      @comment = Comment.find_by(id: params[:id])
      if @comment.update(comment_params)
        respond_to do |format|
          format.turbo_stream { render 'posts/comments/streams/update' }
          format.html { render template: 'groups/sections/posts/show' }
        end
      else
        respond_to do |format|
          render_turbo_flash_alert(format, format_errors(@post))
          format.html { render :edit }
        end
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:content).merge({ user_id: current_user.id })
    end
  end
end
