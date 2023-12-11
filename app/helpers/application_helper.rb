# frozen_string_literal: true

module ApplicationHelper

  def navigation_breadcrumbs(section, topic=nil, post=nil)
    content_tag(:div, class: "mt-2 flex justify-items" ) do
      create_section_tag(section) + create_topic_tag(topic) + create_post_tag(post)
    end
  end

  private

  def create_section_tag(section)
    content_tag(:p, class: "#{action_button} max-w-sm rounded-l-g") do
      link_to("--> Section: #{section.title}", group_section_path(section.group.id, section.id), data: {turbo_action: :advance})
    end
  end

  def create_topic_tag(topic)
    return nil unless topic.present?

    content_tag(:p, class: "#{action_button} max-w-sm rounded-l-g") do
      link_to("--> Topic: #{topic.title}", topic_path(topic.id), data: {turbo_action: :advance})
    end
  end

  def create_post_tag(post)
    return nil unless post.present?

    content_tag(:p, class: "#{action_button} max-w-sm rounded-l-g") do
      link_to("--> Post: #{post.title}", topic_post_path(post.topic.id, post.id), data: {turbo_action: :advance})
    end
  end
end
