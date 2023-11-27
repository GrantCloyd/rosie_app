# frozen_string_literal: true

module Topics
  class PostsController < Topics::BaseTopicsController
    before_action :ensure_logged_in
    before_action :set_topic

    def new; end

    def show
      @post = Post.find(params[:id])

      respond_to do |format|
        format.turbo_stream { render 'topics/posts/streams/show' }
        format.html { render :show }
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to topic_posts_path, notice: 'This post could not be found'
    end

    def index; end

    def edit
      @post = Post.find(params[:id])

      respond_to do |format|
        format.turbo_stream { render 'topics/posts/streams/edit' }
        format.html { render :edit }
      end
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

      respond_to do |format|
        format.turbo_stream { render 'topics/posts/streams/create' }
        format.html { render :index }
      end
    end

    def destroy
      @post = Post.find(params[:id])
      @post.destroy

      respond_to do |format|
        format.turbo_stream { render 'topics/posts/streams/destroy' }
        format.html { render 'topics/posts/index', notice: 'Deleted' }
      end
    end

    def publish
      @post = Post.find(params[:id])
      @post.update!(status: :published, published_on: Date.current)

      respond_to do |format|
        format.turbo_stream { render 'topics/posts/streams/publish' }
        format.html { render :index }
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to topic_posts_path, notice: 'This post could not be found'
    end

    def unpublish
      @post = Post.find(params[:id])
      @post.update!(status: :hidden)

      respond_to do |format|
        format.turbo_stream { render 'topics/posts/streams/unpublish' }
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
