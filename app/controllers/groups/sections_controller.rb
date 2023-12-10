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

    def show
      @section = Section.includes(:topics).find(params[:id])
      @topics = @section.topics
    end

    rescue_from ActiveRecord::RecordNotFound do |_exception|
      redirect_to group_sections_path, notice: 'This section could not be found'
    end

    def edit
      @section = Section.find(params[:id])

      respond_to do |format|
        format.turbo_stream { render 'topics/posts/streams/edit' }
        format.html { render :edit }
      end
    end

    def update
      @section = Section.find(params[:id])
      @section.update!(section_params)
      @topics = @section.topics

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/update' }
        format.html { render 'groups/sections/show' }
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
