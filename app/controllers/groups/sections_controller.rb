# frozen_string_literal: true

module Groups
  class SectionsController < Groups::BaseGroupsController
    def new; end

    def create
      section = ::Sections::CreatorService.new(params: section_params, user: current_user, user_group: @user_group).call

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
      @section = Section.includes(:posts, :user_group_sections).find(params[:id])
      @posts, @unpublished_posts = @section.posts.in_order.partition(&:published?)
      @user_group_section = UserGroupSection.current_user_group_section(user_group: @user_group, section: @section)
    end

    def edit
      @section = Section.find(params[:id])

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/edit' }
        format.html { render :edit }
      end
    end

    def update
      @section = Section.find(params[:id])
      @section.update!(section_params)
      @posts, @unpublished_posts = @section.posts.in_order.partition(&:published?)
      @user_group_section = UserGroupSection.current_user_group_section(user_group: @user_group, section: @section)

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/update' }
        format.html { render 'groups/sections/show' }
      end
    end

    def destroy
      @section = Section.find(params[:id])
      @section.destroy

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/destroy' }
        format.html { redirect_to group_sections_path(@group) }
      end
    end

    def publish
      @section = Section.find(params[:id])
      @section.update!(status: :published)
      @user_group_section = UserGroupSection.current_user_group_section(user_group: @user_group, section: @section)

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/publish' }
        format.html { render :index }
      end
    end

    def unpublish
      @section = Section.find(params[:id])
      @section.update!(status: :hidden)
      @user_group_section = UserGroupSection.current_user_group_section(user_group: @user_group, section: @section)

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/unpublish' }
        format.html { render :index }
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |_exception|
      redirect_to group_sections_path(@group), notice: 'This section could not be found'
    end

    private

    def section_params
      params.require(:section).permit(:title, :description, :status).merge(params.permit(:group_id))
    end
  end
end
