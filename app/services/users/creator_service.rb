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
          attach_invites!
        end
      end

      @user
    end

    private

    def attach_invites!
      invites = Invite.where(target_email: @user.email)
      invites.update_all(user_id: @user.id, updated_at: DateTime.current)
    end

    def create_preferences!
      @user.build_user_preference.save!
    end
  end
end
