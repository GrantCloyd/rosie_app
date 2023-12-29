# frozen_string_literal: true

module UserGroupSections
  class CreateOrFindService
    def initialize(user_group:, section:)
      @user_group = user_group
      @section = section
      @section_role_permission_permission_level = section_role_permission_permission_level
    end

    def call
      create_or_find!
    end

    private

    def create_or_find!
      user_group_section = UserGroupSection.where(user_group: @user_group, section: @section).first_or_initialize

      return user_group_section if user_group_section.persisted?

      if @user_group.creator?
        user_group_section.creator_level!
      else
        assign_permissions_by_tier(user_group_section)
      end

      user_group_section.save!

      user_group_section
    end

    def assign_permissions_by_tier(user_group_section)
      case @section.privacy_tier.to_sym
      when :manual_only_tier
        handle_manual_only_tier(user_group_section)
      when :private_tier
        handle_private_tier_creation(user_group_section)
      else
        use_role_section_permission(user_group_section)
      end
    end

    def handle_manual_only_tier(user_group_section)
      return user_group_section.blocked_level! unless @user_group.all_access?

      use_role_section_permission(user_group_section)
    end

    def handle_private_tier_creation(user_group_section)
      return user_group_section.blocked_level! unless @user_group.private_or_all_access?

      use_role_section_permission(user_group_section)
    end

    def use_role_section_permission(user_group_section)
      if section_role_permission_permission_level.present?
        enum_setter = "#{section_role_permission_permission_level}!".to_sym
        user_group_section.send(enum_setter)
      # shouldn't ever hit this case as permissions should not be removed or missing
      # this is purely a fallback which prefers reader to blocked status
      # and keeping the app working rather than breaking
      else
        user_group_section.reader_level!
      end
    end

    def section_role_permission_permission_level
      @section_role_permission ||= @section.section_role_permissions.find_by(role_tier: @user_group.role)&.permission_level
    end
  end
end
