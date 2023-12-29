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
      enum: :role_tier,
      exception_array:
    )
  end

  def invite_creation_privacy_tiers_options
    select_option_generator(
      model: Invite,
      enum: :privacy_tier
    )
  end
end
