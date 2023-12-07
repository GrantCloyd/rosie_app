# frozen_string_literal: true

module Groups
  class CreatorService
    def initialize(params:, user:)
      @group = Group.new(params)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        if @group.valid?
          create_user_group!
          @group.save!
        end

        @group
      end
    end

    private

    def create_user_group!
      user_group = UserGroup.new(
        user: @user,
        group: @group,
        role: :creator
      )
      user_group.save!
    end
  end
end
