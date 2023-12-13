# frozen_string_literal: true

module InvitesHelper
  def invite_creation_role_tier_options
    Invite.role_tiers.except(:creator).keys.map { |tier| [tier.titleize, tier] }
  end

  def invite_creation_privacy_tiers_options
    Invite.privacy_tiers.keys.map { |privacy_tier| [privacy_tier.titleize, privacy_tier] }
  end
end
