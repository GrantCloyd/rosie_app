# frozen_string_literal: true

class TopicsController < ApplicationController
  before_action :ensure_logged_in
  before_action :set_section, only: %i[new create]

  def index
    @topics = Topic.all
  end

  def new; end

  def show
    @topic = Topic.includes(:section).find(params[:id])
    @section = @topic.section
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update!(topics_params)

    redirect_to topic_path(@topic), notice: 'Topic updated!'
  rescue ActiveRecord::RecordNotFound
    redirect_to topics_path, notice: 'This topic no longer exists'
  end

  def create
    topic = Topics::CreatorService.new(params: topics_params, user: current_user).call

    if topic.errors.present?
      respond_to do |format|
        render_turbo_flash_alert(format, topic.errors.full_messages.to_sentence.to_s)
        format.html { render :new }
      end
    else
      redirect_to group_section_path(current_group, @section), notice: 'Successfuly created!'
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy!

    redirect_to topics_path, notice: 'Topic deleted!'
  rescue ActiveRecord::RecordNotFound
    redirect_to topics_path, notice: 'This topic no longer exists'
  end

  private

  def set_section
    @section ||= Section.find_by(id: section_id) || @topic.section
  end

  def section_id
    params[:section_id] || params.dig(:topic, :section_id)
  end

  def topics_params
    params.require(:topic).permit(:description, :title, :status, :section_id)
  end
end
