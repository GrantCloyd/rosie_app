# frozen_string_literal: true

module GroupsHelper
  def  group_creation_display_statuses
    select_option_generator(
      model: Group,
      enum: :status,
      exception_array: [:archived]
    )
  end
end
