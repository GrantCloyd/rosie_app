# frozen_string_literal: true

module Posts
  class ImagesController < Posts::BasePostsController
    def index
      @images = @post.images
      render layout: false
    end

    def show
      @image = @post.images.find_by(blob_id: params[:id])

      respond_to do |format|
        format.turbo_stream { render 'posts/images/streams/show' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end

    def destroy
      @image = @post.images.find_by(blob_id: params[:id])
      @image.purge

      respond_to do |format|
        format.turbo_stream { render 'posts/images/streams/destroy' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end
  end
end
