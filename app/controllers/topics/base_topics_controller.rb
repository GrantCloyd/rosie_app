# frozen_string_literal: true

module Topics
  class BaseTopicsController < ApplicationController
    private

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def ensure_user_authorized
      return if user_authorized

      redirect_to request.referer, notice: 'This action is not permitted'
    end

    def user_authorized
      current_user.user_topics.where(topic_id: @topic.id, role: %i[moderator creator]).present?
    end
  end
end
