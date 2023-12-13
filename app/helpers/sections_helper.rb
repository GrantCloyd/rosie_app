# frozen_string_literal: true

module SectionsHelper
  def section_creation_display_statuses
    Section.statuses.except(:hidden).keys.map { |status| [status.titleize, status] }
  end

  def section_creation_privacy_tiers_options
    Section.privacy_tiers.keys.map { |privacy_tier| [privacy_tier.titleize, privacy_tier] }
  end
end
