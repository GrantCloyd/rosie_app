# frozen_string_literal: true

module Topics
  class PostsController < Topics::BaseTopicsController
    before_action :ensure_logged_in
    before_action :set_topic

    def new; end

    def show
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to topic_posts_path, notice: 'This post could not be found'
    end

    def index
      @posts = @topic.posts
    end

    def edit
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to topic_posts_path, notice: 'This post could not be found'
    end

    def update
      @post = Post.find(params[:id])
      @post.update!(post_params)

      redirect_to topic_post_path(@post), notice: 'Successfully updated!'
    rescue ActiveRecord::RecordNotFound
      redirect_to topic_posts_path, notice: 'This post could not be found'
    end

    def create
      @topic.posts.create!(post_params)

      redirect_to topic_posts_path, notice: 'New post created. Remember to publish!'
    end

    def publish
      @post = Post.find(params[:id])
      @post.update!(status: :published, published_on: Date.current)

      # TODO: - update individual item when published
      respond_to do |format|
        render_turbo_flash_alert(format, "'#{@post.title}' has been published!")
        format.html { render :index }
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to topic_posts_path, notice: 'This post could not be found'
    end

    def unpublish
      @post = Post.find(params[:id])
      @post.update!(status: :hidden)

      # TODO: - update individual item when unpublished
      respond_to do |format|
        render_turbo_flash_alert(format, "'#{@post.title}' has been hidden!")
        format.html { render :index }
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to topic_posts_path, notice: 'This post could not be found'
    end

    private

    def post_params
      params.require(:post).permit(:title, :description, :content)
    end
  end
end
