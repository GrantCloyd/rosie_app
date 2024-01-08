# frozen_string_literal: true

module Invites
  class AcceptService
    def initialize(invite:)
      @invite = invite
    end

    def call
      @user_group = convert_invite_to_user_group

      if @user_group.save!
        update_invite_status!
        create_user_group_sections!
        notify_group_creator!
      end

      @user_group
    end

    private

    def convert_invite_to_user_group
      UserGroup.new(
        group_id: @invite.group_id,
        role: @invite.role_tier,
        privacy_tier: @invite.privacy_tier,
        user_id: @invite.user_id
      )
    end

    def update_invite_status!
      @invite.update!(status: :accepted)
    end

    def notify_group_creator!
      Invites::MemberJoinedNotificationJob.perform_later(@invite.group_id, @invite.user_id)
    end

    def create_user_group_sections!
      Invites::CreateUserGroupSectionsJob.perform_later(@user_group.id)
    end
  end
end
