# frozen_string_literal: true

module Sections
  class CreatorService
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

    # currently a creator srp is not defined/created as users with creator roles are given all permissions
    def create_default_section_role_permissions
      SectionRolePermission::DEFAULT_TIER_TO_PERMISSION_MAP.each do |role_tier, permission_level|
        SectionRolePermission.create(section: @section, role_tier:, permission_level:)
      end
    end
  end
end
