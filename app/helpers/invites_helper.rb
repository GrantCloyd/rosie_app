# frozen_string_literal: true

module InvitesHelper
  def invite_creation_invite_tier_options
    Invite.role_tiers.except(:creator).keys.map { |tier| [tier.titleize, tier] }
  end
end
