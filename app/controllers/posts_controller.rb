class PostsController < ApplicationController
  before_action :set_topic

  def new
    @post = Post.new
  end

  def index
    @posts = @topic.posts
  end

  def create
    @topic.posts.create!(post_params)

    redirect_to topic_posts_path, notice: "New post created. Remember to publish!"
  end

  def publish
    @post = Post.find(params[:id])
    @post.update(status: :published, published_on: Date.current)

    redirect_to topic_posts_path, notice: "Post published!"

  rescue ActiveRecord::RecordNotFound
    redirect_to topic_posts_path, notice: "This post could not be found"
  end

  private 

  def post_params
    params.require(:post).permit(:title, :description, :content)
  end

  def set_topic
    @topic = Topic.find(params[:topic_id])
  end
end
