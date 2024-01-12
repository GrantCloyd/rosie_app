# frozen_string_literal: true

module Groups
  module Sections
    class BaseSectionsController < Groups::BaseGroupsController
      before_action :set_section
      before_action :set_user_group_section
      before_action :ensure_user_group_section_authorized

      private

      def set_section
        @section = Section.find(params[:section_id])
      end

      def set_user_group_section
        @user_group_section = UserGroupSection.find_by(user_group: @user_group, section: @section)
      end

      def ensure_user_group_section_authorized
        @user_group_section.present?
      end
    end
  end
end
