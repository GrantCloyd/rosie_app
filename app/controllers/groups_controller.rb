# frozen_string_literal: true

class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update!(groups_params)

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
      format.turbo_stream
      format.html { render 'groups/index', notice: 'Deleted' }
    end
  end

  private

  def group_params
    params.require(:group).permit(:status, :title)
  end
end
