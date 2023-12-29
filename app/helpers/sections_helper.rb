# frozen_string_literal: true

module SectionsHelper
  def section_creation_display_statuses
    select_option_generator(
      model: Section,
      plural_enum: :statuses,
      exception_array: [:hidden]
    )
  end

  def section_creation_privacy_tiers_options
    select_option_generator(
      model: Section,
      plural_enum: :privacy_tiers
    )
  end
end
