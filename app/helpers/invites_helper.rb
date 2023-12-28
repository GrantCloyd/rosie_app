# frozen_string_literal: true

module InvitesHelper
  def invite_creation_role_tier_options
    select_option_generator(
      model: Invite,
      enum: :role_tiers,
      exception_array: [:creator]
    )
  end

  def invite_creation_privacy_tiers_options
    select_option_generator(
      model: Invite,
      enum: :privacy_tier
    )
  end
end
