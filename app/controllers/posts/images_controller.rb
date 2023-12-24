# frozen_string_literal: true

module Posts
  class ImagesController < Posts::BasePostsController
    def show
      @image = @post.images.find_by(blob_id: params[:id])

      respond_to do |format|
        format.turbo_stream { render 'posts/images/streams/show' }
        format.html { render template: 'groups/sections/posts/show' }
      end
    end
  end
end
