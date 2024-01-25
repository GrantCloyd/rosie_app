# frozen_string_literal: true

module Invites
  class MemberJoinedNotificationJob < ApplicationJob
    queue_as :default

    def perform(group_id, new_user_id)
      new_user = User.find_by(id: new_user_id)
      group_title = Group.find_by(id: group_id)&.title
      group_creator = User.joins(:user_groups)
                          .find_by(user_groups: { group_id:, role: :creator })

      return Rollbar.error("#{group_id} or #{new_user_id} had an error on sign up") unless new_user && group_title && group_creator

      GroupInviteMailer
        .with(
          { new_user:,
            group_title:,
            group_creator: }
        )
        .notify_group_creator
        .deliver_later
    end
  end
end
