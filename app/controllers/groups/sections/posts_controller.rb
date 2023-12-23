# frozen_string_literal: true

module Groups
  module Sections
    class PostsController < Groups::Sections::BaseSectionsController
      before_action :set_user_group_section

      def new; end

      def show
        @post = Post.includes(:comments).find(params[:id])
        @comments = @post.comments

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/show' }
          format.html { render :show }
        end
      end

      def edit
        @post = Post.find(params[:id])

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/edit' }
          format.html { render :edit }
        end
      end

      def update
        @post = Post.includes(:comments).find(params[:id])
        @post.update!(post_params)
        @comments = @post.comments

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/update' }
          format.html { render :show }
        end
      end

      def create
        resize_images_before_save(post_params[:images])
        @section.posts.create!(post_params.merge(user_group_section_id: @user_group_section.id))

        redirect_to group_section_path(@group, @section)
      end

      def destroy
        @post = Post.find(params[:id])
        @post.destroy

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/destroy' }
          format.html { render 'groups/sections/posts/index', notice: 'Deleted' }
        end
      end

      def publish
        @post = Post.find(params[:id])
        @post.update!(status: :published, published_on: DateTime.now.utc)

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/publish' }
          format.html { render :index }
        end
      end

      def unpublish
        @post = Post.find(params[:id])
        @post.update!(status: :hidden)

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/unpublish' }
          format.html { render :index }
        end
      end

      rescue_from ActiveRecord::RecordNotFound do |_exception|
        redirect_to group_sections_path(@group, @section), notice: 'This post could not be found'
      end

      private

      def post_params
        params.require(:post).permit(:title, :status, :content, images: [])
      end

      def resize_images_before_save(images)
        images.each do |image|
          next unless image.is_a?(ActionDispatch::Http::UploadedFile)

          binding.pry

          ImageProcessing::MiniMagick
            .source(image)
            .resize_to_fit(1200)
        end
      end
    end
  end
end
