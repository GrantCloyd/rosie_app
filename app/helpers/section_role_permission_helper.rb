# frozen_string_literal: true

module SectionRolePermissionHelper
  def select_permission_level_options
    select_option_generator(
      model: SectionRolePermission,
      plural_enum: :permission_levels
    )
  end
end
