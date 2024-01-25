# frozen_string_literal: true

module UserGroupSections
  class MassUpsertByRoleTierJob < ApplicationJob
    queue_as :default

    def perform(section_id, role_tier)
      section = Section.find_by(id: section_id)
      user_groups = UserGroup.where(group_id: section.group_id, role: role_tier)

      return unless user_groups && section

      user_group_section_attributes = build_user_group_section_attributes(user_groups, section, role_tier)

      unless user_group_section_attributes
        return Rollbar.error("Setion id: #{section.id}, title: #{section.title} is missing one or more permissions")
      end

      UserGroupSection.upsert_all(user_group_section_attributes, unique_by: %i[user_group_id section_id])
    end

    private

    def build_user_group_section_attributes(user_groups, section, role_tier)
      if role_tier == 'creator'
        build_creator_attributes(user_groups, section)
      else
        permission_level = SectionRolePermission.find_by(section_id: section.id, role_tier:)&.permission_level

        return unless permission_level.present?

        build_non_creator_group_section_attributes(user_groups, section, permission_level)
      end
    end

    def build_creator_attributes(user_groups, section)
      user_groups.map do |user_group|
        {
          user_group_id: user_group.id,
          section_id: section.id,
          permission_level: :creator_level
        }
      end
    end

    def build_non_creator_group_section_attributes(user_groups, section, permission_level)
      user_groups.map do |user_group|
        id_attributes = {
          user_group_id: user_group.id,
          section_id: section.id
        }

        if passing_privacy_tier_requirement?(user_group.privacy_tier, section.privacy_tier)
          id_attributes.merge({ permission_level: })
        else
          id_attributes.merge({ permission_level: :blocked_level })
        end
      end
    end

    # all other cases will fail, causing a blocked level
    def passing_privacy_tier_requirement?(user_group_privacy_tier, section_privacy_tier)
      user_group_privacy_tier == 'all_access' ||
        (user_group_privacy_tier == 'private_tier' && section_privacy_tier != 'manual_only_tier') ||
        (user_group_privacy_tier == 'no_private_access' && section_privacy_tier == 'open_tier')
    end
  end
end
