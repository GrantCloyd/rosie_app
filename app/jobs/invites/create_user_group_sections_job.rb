# frozen_string_literal: true

module Invites
  class CreateUserGroupSectionsJob < ApplicationJob
    queue_as :default

    def perform(user_group_id)
      user_group = UserGroup.includes(group: :sections).find_by(id: user_group_id)

      return unless user_group.present?

      user_group.group.sections.each do |section|
        UserGroupSections::CreateOrFindService.new(user_group:, section:).call
      end
    end
  end
end
