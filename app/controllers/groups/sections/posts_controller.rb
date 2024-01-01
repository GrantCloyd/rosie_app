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
        if @post.update(post_params)
          @comments = @post.comments

          respond_to do |format|
            format.turbo_stream { render 'groups/sections/posts/streams/update' }
            format.html { render :show }
          end
        else
          respond_to do |format|
            render_turbo_flash_alert(format, format_errors(@post))
            format.html { render :edit }
          end
        end
      end

      def create # rubocop:disable Metrics/MethodLength
        @post = @section.posts.new(post_params.merge(user_group_section_id: @user_group_section.id))
        @post.valid?

        if @post.errors.present?
          respond_to do |format|
            render_turbo_flash_alert(format, format_errors(@post))
            format.html { render :new }
          end
        else
          @posts, @unpublished_posts = @section.posts.in_order.partition(&:published?)
          respond_to do |format|
            format.turbo_stream { render 'groups/sections/posts/streams/create' }
            format.html do
              render template: 'groups/sections/show', group: @group, section: @section, posts: @posts, unpublished_posts: @unpublished_posts
            end
          end
        end
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
    end
  end
end
