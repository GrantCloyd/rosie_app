# frozen_string_literal: true

module UserGroupSections
  class CreateOrFindService
    def initialize(user_group:, section:)
      @user_group = user_group
      @section = section
    end

    def call
      create_or_find!
    end

    private

    def create_or_find!
      user_group_section = UserGroupSection.where(user_group: @user_group, section: @section).first_or_initialize

      return user_group_section if user_group_section.persisted?

      assign_permissions_by_tier(user_group_section)

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
        use_default_level(user_group_section)
      end
    end

    def handle_manual_only_tier(user_group_section)
      if @user_group.all_access?
        user_group_section.moderator!
      else
        @user_group_section.blocked!
      end

      user_group_section
    end

    # This is a default/fallback behavior that will need to be updated when building out permissions
    def handle_private_tier_creation(user_group_section)
      return user_group_section.blocked! unless @user_group.private_or_all_access?

      use_default_level(user_group_section)
    end

    def use_default_level(user_group_section)
      case @user_group.role.to_sym
      when :moderator
        user_group_section.moderator!
      when :subscriber
        user_group_section.commenter!
      # shouldn't hit this case, this is purely fallback which prefers reader to blocked status
      else
        user_group_section.reader!
      end
    end
  end
end
