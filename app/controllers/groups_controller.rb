# frozen_string_literal: true

class GroupsController < ApplicationController
  def index
    exit_group

    @groups = current_user.groups.in_order

    respond_to do |format|
      format.turbo_stream { render 'groups/streams/index' }
      format.html { render :index }
    end
  end

  def new; end

  def show
    @group = Group.includes(:sections).find(params[:id])
    @sections = @group.sections
    select_group(@group)

    respond_to do |format|
      format.turbo_stream { render 'groups/streams/show' }
      format.html { render :show }
    end
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
    @group.update!(group_params)

    redirect_to group_path(@group), notice: 'group updated!'
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, notice: 'This group no longer exists'
  end

  def create
    group = Groups::CreatorService.new(params: group_params, user: current_user).call

    if group.errors.present?
      respond_to do |format|
        render_turbo_flash_alert(format, group.errors.full_messages.to_sentence.to_s)
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
end
