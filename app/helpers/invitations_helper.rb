module InvitationsHelper

  def invitation_creation_invite_tier_options
    Invitation.invite_tiers.except(:creator).keys.map {|tier| [tier.titleize, tier]}
  end
end
