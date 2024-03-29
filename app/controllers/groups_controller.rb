# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :ensure_logged_in

  def index
    exit_group

    @groups = current_user.groups.in_order
    @invites = @current_user.invites.pending_or_email_sent
  end

  def new; end

  def show
    @group = Group.includes(:sections).find(params[:id])
    @pinned_sections, @sections, @pending_sections = group_sections_sorter(@group.sections.in_order)
    @user_group = @group.current_user_group(current_user)
    select_group(@group)
  end

  def edit
    @group = Group.find(params[:id])

    respond_to do |format|
      format.turbo_stream { render 'groups/streams/edit' }
      format.html { render :edit }
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to group_path(@group), notice: 'group updated!'
    else
      respond_to do |format|
        render_turbo_flash_alert(format, format_errors(group))
        format.html { render :edit }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, notice: 'This group no longer exists'
  end

  def create
    group = Groups::CreatorService.new(params: group_params, user: current_user).call

    if group.errors.present?
      respond_to do |format|
        render_turbo_flash_alert(format, format_errors(group))
        format.html { render :new }
      end
    else
      redirect_to groups_path
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.turbo_stream { render 'groups/streams/destroy' }
      format.html { render 'groups/index', notice: 'Deleted' }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    redirect_to groups_path, notice: 'This group could not be found'
  end

  private

  def group_params
    params.require(:group).permit(:status, :title)
  end

  def group_sections_sorter(sections)
    pinned = []
    published = []
    pending = []

    sections.each do |section|
      if section.pinned?
        pinned << section
      elsif section.published?
        published << section
      else
        pending << section
      end
    end

    [pinned, published, pending]
  end
end
