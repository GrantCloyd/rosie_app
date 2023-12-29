# frozen_string_literal: true

module Sections
  class CreatorService
    SECTION_ROLE_PERMISSION_CREATION_TIERS = SectionRolePermission.role_tiers.except(:creator).keys

    def initialize(params:, user:, user_group:)
      @section = Section.new(params)
      @user = user
      @user_group = user_group
    end

    def call
      @section.user_id = @user.id
      ActiveRecord::Base.transaction do
        if @section.valid?
          create_user_group_section
          create_default_section_role_permissions
          @section.save!
        end

        @section
      end
    end

    def create_user_group_section
      UserGroupSection.create(
        section: @section,
        user_group: @user_group,
        permission_level: :creator_level
      )
    end

    def create_default_section_role_permissions
      SectionRolePermission::DEFAULT_TIER_TO_PERMISSION_MAP.each do |role_tier, permission_level|
        SectionRolePermission.create(section: @section, role_tier:, permission_level:)
      end
    end
  end
end
