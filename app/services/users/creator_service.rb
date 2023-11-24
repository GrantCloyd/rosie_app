# frozen_string_literal: true

module Users
  class CreatorService
    def initialize(params:)
      @user = User.new(params)
    end

    def call
      ActiveRecord::Base.transaction do
        if @user.valid?
          create_preferences!
          @user.save!
        end
      end

      @user
    end

    private

    def create_preferences!
      @user.build_user_preference
      @user.user_preference.save!
    end
  end
end
