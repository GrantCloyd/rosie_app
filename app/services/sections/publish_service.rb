# frozen_string_literal: true

module Sections
  class PublishService
    def initialize(section)
      @section = section
    end

    def call
      create_user_group_sections
    end

    private

    def create_user_group_sections
      UserGroup.roles.each_key do |role_tier|
        UserGroupSections::MassUpsertByRoleTierJob.perform_later(@section.id, role_tier)
      end
    end
  end
end
