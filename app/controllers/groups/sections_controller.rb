# frozen_string_literal: true

module Groups
  class SectionsController < Groups::BaseGroupsController
    def new; end

    def create
      section = ::Sections::CreatorService.new(
        params: section_params,
        user: current_user,
        user_group: @user_group
      ).call

      if section.errors.present?
        respond_to do |format|
          render_turbo_flash_alert(format, format_errors(section))
          format.html { render :new }
        end
      else
        redirect_to group_path(section.group)
      end
    end

    def show
      @section = Section.includes(:posts, :section_role_permissions).find(params[:id])
      @user_group_section = UserGroupSections::CreateOrFindService.new(user_group: @user_group, section: @section).call

      if @user_group_section.blocked_level?
        respond_to do |format|
          format.html { redirect_to group_path(@group), flash: { alert: 'This group is private' } }
        end
      else
        @posts, @unpublished_posts = @section.posts.in_order.partition(&:published?)
      end
    end

    def edit
      @section = Section.includes(:section_role_permissions).find(params[:id])

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/edit' }
        format.html { render :edit }
      end
    end

    def update
      @section = Section.includes(:section_role_permissions).find(params[:id])
      if @section.update(section_update_params)
        @posts, @unpublished_posts = @section.posts.in_order.partition(&:published?)
        @user_group_section = UserGroupSection.current_user_group_section(user_group: @user_group, section: @section)

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/streams/update' }
          format.html { render 'groups/sections/show' }
        end
      else
        respond_to do |format|
          render_turbo_flash_alert(format, format_errors(@section))
          format.html { render 'groups/sections/show' }
        end
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

      ::Sections::PublishService.new(@section).call

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
      params.require(:section)
            .permit(:title, :description, :status, :privacy_tier)
            .merge(params.permit(:group_id))
    end

    def section_update_params
      section_params.merge(section_role_permissions_attributes_params)
    end

    def section_role_permissions_attributes_params
      spra_array = params[:section][:section_role_permissions_attributes].each.with_object([]) do |(_, attributes), res|
        res << attributes.permit(:role_tier, :permission_level, :id)
      end

      { section_role_permissions_attributes: spra_array }
    end
  end
end
