# frozen_string_literal: true

module Groups
  class BaseGroupsController < ApplicationController
    before_action :set_group
    before_action :set_user_group
    before_action :ensure_logged_in
    before_action :ensure_user_authorized

    def section_post_sorter(posts)
      pinned = []
      published = []
      unpublished = []

      posts.each do |post|
        if post.pin_index.present?
          pinned << post
        elsif post.published?
          published << post
        else
          unpublished << post
        end
      end
      [pinned, published, unpublished]
    end

    private

    def set_group
      @group = current_group
    end

    def set_user_group
      @user_group ||= UserGroup.find_by(user: current_user, group: current_group)
    end

    def ensure_user_authorized
      return if user_authorized

      redirect_to request.referer, notice: 'This action is not permitted'
    end

    def user_authorized
      @user_group.present?
    end
  end
end
