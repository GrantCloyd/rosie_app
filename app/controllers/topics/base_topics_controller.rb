class Topics::BaseTopicsController < ApplicationController

  private
  
  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def ensure_user_authorized
    current_user.user_topics.where(topic_id: @topic.id, role: [:moderator, :creator]).present?
  end
end