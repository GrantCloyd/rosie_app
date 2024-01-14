# frozen_string_literal: true

module Groups
  module Sections
    class PostsController < Groups::Sections::BaseSectionsController # rubocop:disable Metrics/ClassLength
      before_action :set_user_group_section

      def new; end

      def show
        @post = Post.find(params[:id])

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
        @post = @section.posts.new(post_params.merge(user_id: current_user.id))
        @post.valid?

        if @post.errors.present?
          respond_to do |format|
            render_turbo_flash_alert(format, format_errors(@post))
            format.html { render :new }
          end
        else
          @post.save!
          @pinned_posts, @posts, @unpublished_posts = section_post_sorter(@section.posts.in_order)
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

        UnpinService.new(pinnable: @post, belongs_to_assoc: @section).call if @post.pinned?
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
        UnpinService.new(pinnable: @post, belongs_to_assoc: @section).call unless @post.pin_index.nil?
        @post.update!(status: :hidden)

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/unpublish' }
          format.html { render :index }
        end
      end

      def pin
        @post = Post.find(params[:id])
        current_post_index = @section.posts.where.not(pin_index: nil).count
        @post.update(pin_index: current_post_index)

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/pin' }
          format.html { redirect_to group_section_path(current_group, section) }
        end
      end

      def unpin
        @post = Post.find(params[:id])

        if @post.pin_index.nil?
          render_turbo_flash_alert(format, 'Post is not currently pinned')
          format.html { redirect_to groups_section_path(current_group, @section) }
        end

        UnpinService.new(pinnable: @post, belongs_to_assoc: @section).call

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/posts/streams/unpin' }
          format.html { redirect_to group_section_path(current_group, section) }
        end
      end

      def pin_shift
        pin_index = params[:pin_index].to_i
        shift_direction = params[:shift_direction].to_sym

        pin_indices = shift_direction == :up ? [pin_index, pin_index - 1] : [pin_index, pin_index + 1]
        posts = Post.where(pin_index: pin_indices).order(:pin_index)

        if posts.size == 2

          @new_low_index_post, @new_high_index_post = swap_and_save(posts.first, posts.last)

          respond_to do |format|
            format.turbo_stream { render 'groups/sections/posts/streams/pin_shift' }
            format.html { redirect_to group_section_path(current_group, section) }
          end
        else
          respond_to do |format|
            render_turbo_flash_alert(format, 'Post can not be reordered')
            format.html { redirect_to groups_path(current_group) }
          end
        end
      end

      rescue_from ActiveRecord::RecordNotFound do |_exception|
        redirect_to group_sections_path(@group, @section), notice: 'This post could not be found'
      end

      private

      def post_params
        params.require(:post).permit(:title, :status, :content, images: [])
      end

      def swap_and_save(low_index, high_index)
        temp_index = low_index.pin_index

        low_index.pin_index = high_index.pin_index
        high_index.pin_index = temp_index
        # NOTE: 'high_index' now is the lower index
        [high_index, low_index].each(&:save)
      end
    end
  end
end
