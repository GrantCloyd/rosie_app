# frozen_string_literal: true

module SectionsHelper
  def section_creation_display_statuses
    Section.statuses.except(:hidden).keys.map { |status| [status.titleize, status] }
  end
end
