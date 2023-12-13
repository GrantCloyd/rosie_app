# frozen_string_literal: true

module ApplicationHelper
  def current_user
    User.find_by(id: session[:user_id])
  end

  def current_group
    User.find_by(id: session[:group_id])
  end

  def navigation_breadcrumbs(group, section = nil, post = nil)
    content_tag(:div, class: 'mt-2 flex justify-items') do
      create_group_tag(group) +
        create_section_tag(group, section) +
        create_post_tag(group, section, post)
    end
  end

  private

  def create_group_tag(group)
    content_tag(:p, class: "#{action_button} max-w-sm rounded-l-g") do
      link_to("--> Group: #{group.title}", group_path(group), data: { turbo_action: :advance })
    end
  end

  def create_section_tag(group, section)
    return nil unless section.present?

    content_tag(:p, class: "#{action_button} max-w-sm rounded-l-g") do
      link_to("--> Section: #{section.title}", group_section_path(group, section), data: { turbo_action: :advance })
    end
  end

  def create_post_tag(group, section, post)
    return nil unless post.present?

    content_tag(:p, class: "#{action_button} max-w-sm rounded-l-g") do
      link_to("--> Post: #{post.title}", group_section_post_path(group, section, post), data: { turbo_action: :advance })
    end
  end
end
