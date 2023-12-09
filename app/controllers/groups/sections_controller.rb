# frozen_string_literal: true

module Groups
  class SectionsController < ApplicationController
    before_action :set_group

    def new; end

    def create
      section = Sections::CreatorService.new(params: section_params, user: current_user).call

      if section.errors.present?
        respond_to do |format|
          render_turbo_flash_alert(format, section.errors.full_messages.to_sentence.to_s)
          format.html { render :new }
        end
      else
        redirect_to group_path(section.group)
      end
    end

    private

    def set_group
      @group = Group.find(params[:group_id])
    end

    def section_params
      params.require(:section).permit(:title, :description, :status).merge(params.permit(:group_id))
    end
  end
end
