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

  def create
    Topic.create!(topics_params)
    
    redirect_to request.referer, notice: "Successfuly created"

    rescue ArgumentError => error
      redirect_to request.referer, notice: "Not Sucessfully created. Error: #{error.message}"
  end

  def topics_params
    params.require(:topic).permit(:description, :title, :status)
  end
end
