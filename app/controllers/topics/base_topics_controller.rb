# frozen_string_literal: true

module Topics
  class BaseTopicsController < ApplicationController
    private

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end
  end
end
