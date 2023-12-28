# frozen_string_literal: true

module NavigationHelper
  include CssHelper

  def navigation_breadcrumbs(group, section = nil, post = nil)
    content_tag(:div, class: 'mt-2 flex justify-items') do
      nav_tag +
        create_group_tag(group) +
        create_section_tag(group, section) +
        create_post_tag(group, section, post)
    end
  end

  private

  def nav_tag
    content_tag(:p, class: "font-medium #{nav_breadcrumbs}") do
      'Navigation'
    end
  end

  def create_group_tag(group)
    content_tag(:p, class: "#{nav_breadcrumbs} hover:text-emerald-600") do
      link_to("-> Group: #{group.title} ", group_path(group), data: { turbo_action: :advance })
    end
  end

  def create_section_tag(group, section)
    return nil unless section.present?

    content_tag(:p, class: "#{nav_breadcrumbs} hover:text-emerald-600") do
      link_to("-> Section: #{section.title}", group_section_path(group, section), data: { turbo_action: :advance })
    end
  end

  def create_post_tag(group, section, post)
    return nil unless post.present?

    content_tag(:p, class: "#{nav_breadcrumbs} hover:text-emerald-600") do
      link_to("-> Post: #{post.title}", group_section_post_path(group, section, post), data: { turbo_action: :advance })
    end
  end
end
