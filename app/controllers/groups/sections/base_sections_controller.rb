# frozen_string_literal: true

module Groups
  module Sections
    class BaseSectionsController < BaseGroupsController
      before_action :set_section
      before_action :set_user_section
      before_action :ensure_user_section_authorized

      private

      def set_section
        @section = Section.find(params[:section_id])
      end

      def set_user_section
        @user_section = UserSection.find_by(user: current_user, section: @section)
      end

      def ensure_user_section_authorized
        @user_section.present?
      end
    end
  end
end
