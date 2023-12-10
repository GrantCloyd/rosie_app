# frozen_string_literal: true

module Topics
  class CreatorService
    def initialize(params:, user:)
      @topic = Topic.new(params.merge(user_id: user.id))
    end

    def call
      ActiveRecord::Base.transaction do
        if @topic.valid?
          # create_user_topic!
          @topic.save!
        end

        @topic
      end
    end
  end
end
