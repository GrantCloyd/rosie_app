# frozen_string_literal: true

module Topics
  class CreatorService
    def initialize(params:, user:)
      @topic = Topic.new(params)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        if @topic.valid?
          create_user_topic!
          @topic.save!
        end

        @topic
      end
    end

    private

    def create_user_topic!
      user_topic = UserTopic.new(
        user: @user,
        topic: @topic,
        role: :creator
      )
      user_topic.save!
    end
  end
end
