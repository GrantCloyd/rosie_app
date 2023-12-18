# frozen_string_literal: true

module Invites
  class MemberJoinedNotificationJob < ApplicationJob
    queue_as :default

    def perform(group_id, new_user_id)
      new_user = User.find_by(id: new_user_id)
      group_title = Group.find_by(id: group_id)&.title
      group_creator = User.joins(:user_groups)
                          .find_by(user_groups: { group_id:, role: :creator })

      # TODO: - add some kind of error log
      return unless new_user && group_title && group_creator

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
