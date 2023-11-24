class TopicsController < ApplicationController
  before_action :ensure_logged_in

  def index
    @topics = Topic.joins(:user_topics).where(user_topics: {user: current_user})
  end

  def new
    @topic = Topic.new
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update!(topics_params)

    redirect_to topic_path(@topic), notice: "Topic updated!"

  rescue ActiveRecord::RecordNotFound
    redirect_to topics_path, notice: "This topic no longer exists"
  end

  def create
    topic = Topics::CreatorService.new(params: topics_params, user: current_user).call
    
    if topic.errors.present?
      respond_to do |format|
        render_turbo_flash_alert(format, "#{topic.errors.full_messages.to_sentence}")
        format.html { render :new } 
      end
    else
      redirect_to topic_path(topic), notice: "Successfuly created!"
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy!

    redirect_to topics_path, notice: "Topic deleted!"

  rescue ActiveRecord::RecordNotFound
    redirect_to topics_path, notice: "This topic no longer exists"
  end

  private

  def topics_params
    params.require(:topic).permit(:description, :title, :status)
  end
end
