# frozen_string_literal: true

module InvitesHelper
  def invite_creation_role_tier_options(user_group)
    exception_array = if user_group.creator?
                        []
                      else
                        [:creator]
                      end

    select_option_generator(
      model: Invite,
      plural_enum: :role_tiers,
      exception_array:
    )
  end

  def invite_creation_privacy_tiers_options(user_group)
    exception_array = []
    exception_array << :all_access if user_group.moderator?
    exception_array << :private_access if user_group.no_private_access?

    select_option_generator(
      model: Invite,
      plural_enum: :privacy_tiers,
      exception_array:
    )
  end
end
