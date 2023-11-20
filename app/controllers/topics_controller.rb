class TopicsController < ApplicationController

  def index
    @topics = Topic.all
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
    @topic = Topic.create!(topics_params)
    
    redirect_to topic_path(@topic), notice: "Successfuly created!"

    rescue ArgumentError => error
      redirect_to request.referer, notice: "Not Sucessfully created. Error: #{error.message}"
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy!

    redirect_to topics_path, notice: "Topic deleted!"

  rescue ActiveRecord::RecordNotFound
    redirect_to topics_path, notice: "This topic no longer exists"
  end

  def topics_params
    params.require(:topic).permit(:description, :title, :status)
  end
end
