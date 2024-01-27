# frozen_string_literal: true

module Invites
  class MemberJoinedNotificationJob < ApplicationJob
    queue_as :default

    def perform(group_id, new_user_id)
      new_user_full_name = User.find_by(id: new_user_id)&.full_name
      group_title = Group.find_by(id: group_id)&.title
      group_creator_email = User.joins(:user_groups)
                                .where(user_groups: { group_id:, role: :creator })
                                .order(:created_at).limit(1).first&.email

      return Rollbar.error("#{group_id} or #{new_user_id} had an error on sign up") unless new_user && group_title && group_creator

      GroupInviteMailer
        .with(
          { new_user_full_name:,
            group_title:,
            group_creator_email: }
        )
        .notify_group_creator
        .deliver_later
    end
  end
end
