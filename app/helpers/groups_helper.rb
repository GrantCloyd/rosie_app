# frozen_string_literal: true

module GroupsHelper
  def  group_creation_display_statuses
    Group.statuses.except(:archived).keys.map { |group| [group.titleize, group] }
  end
end
