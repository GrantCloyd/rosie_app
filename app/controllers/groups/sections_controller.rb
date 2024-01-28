# frozen_string_literal: true

module Groups
  class SectionsController < Groups::BaseGroupsController # rubocop:disable Metrics/ClassLength
    before_action :set_section, only: %i[show destroy update]
    # fewer eager loads
    before_action :set_section_for_custom_actions, only: %i[pin unpin publish unpublish]
    before_action :set_user_group_section, only: %i[show pin unpin edit update publish unpublish]

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
        redirect_to group_path(current_group)
      end
    end

    def show
      if @user_group_section.blocked_level?
        respond_to do |format|
          format.html { redirect_to group_path(@group), flash: { alert: 'This group is private' } }
        end
      else
        @pinned_posts, @posts, @unpublished_posts = section_post_sorter(@section.posts.in_order)
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
      if @section.update(section_update_params)
        @pinned_posts, @posts, @unpublished_posts = section_post_sorter(@section.posts.in_order)

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/streams/update' }
          format.html { edirect_to group_sections_path(@group) }
        end
      else
        respond_to do |format|
          render_turbo_flash_alert(format, format_errors(@section))
          format.html { redirect_to group_sections_path(@group) }
        end
      end
    end

    def destroy
      UnpinService.new(pinnable: @section, belongs_to_assoc: current_group).call if @section.pinned?
      @section.destroy

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/destroy' }
        format.html { redirect_to group_sections_path(@group) }
      end
    end

    def publish
      @section.update!(status: :published)

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/publish' }
        format.html { render :index }
      end
    end

    def unpublish
      @section.update!(status: :hidden)

      UnpinService.new(pinnable: @section, belongs_to_assoc: current_group).call if @section.pinned?

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/unpublish' }
        format.html { render :index }
      end
    end

    def pin
      current_section_index = @group.sections.where.not(pin_index: nil).count
      @section.update(pin_index: current_section_index)

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/pin' }
        format.html { redirect_to group_path(current_group) }
      end
    end

    def unpin
      if @section.pin_index.nil?
        render_turbo_flash_alert(format, 'Section is not currently pinned')
        format.html { redirect_to groups_path(@current_group) }
      end

      UnpinService.new(pinnable: @section, belongs_to_assoc: current_group).call

      respond_to do |format|
        format.turbo_stream { render 'groups/sections/streams/unpin' }
        format.html { redirect_to group_section_path(current_group, section) }
      end
    end

    def pin_shift
      pin_indices = pin_shift_direction == :up ? [pin_shift_index, pin_shift_index - 1] : [pin_shift_index, pin_shift_index + 1]
      sections = Section.where(pin_index: pin_indices).order(:pin_index)

      if sections.size == 2

        @new_low_index_section, @new_high_index_section = swap_and_save(sections.first, sections.last)
        @user_group_sections = UserGroupSection.where(user_group: @user_group, section: sections)

        respond_to do |format|
          format.turbo_stream { render 'groups/sections/streams/pin_shift' }
          format.html { redirect_to group_path(current_group) }
        end
      else
        respond_to do |format|
          render_turbo_flash_alert(format, 'Section can not be reordered')
          format.html { redirect_to group_path(current_group) }
        end
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |_exception|
      redirect_to group_path(current_group), notice: 'This section could not be found'
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

    def swap_and_save(low_index, high_index)
      temp_index = low_index.pin_index

      low_index.pin_index = high_index.pin_index
      high_index.pin_index = temp_index
      # NOTE: 'high_index' now is the lower index
      [high_index, low_index].each(&:save)
    end

    def set_section
      @section = Section.includes(:posts, :section_role_permissions).find(params[:id])
    end

    def set_section_for_custom_actions
      @section = Section.find(params[:id])
    end

    def set_user_group_section
      @user_group_section ||= UserGroupSection.current_user_group_section(user_group: @user_group, section: @section)
    end

    def pin_shift_index
      @pin_shift_index ||= pin_shift_params[:pin_index].to_i
    end

    def pin_shift_direction
      @pin_shift_direction ||= pin_shift_params[:shift_direction].to_sym
    end

    def pin_shift_params
      params.permit(:pin_index, :shift_direction)
    end
  end
end
