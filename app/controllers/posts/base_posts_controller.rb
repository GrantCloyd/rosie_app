# frozen_string_literal: true

module Posts
  class BasePostsController < ApplicationController
    before_action :set_post
    before_action :set_user_group_section

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_user_group_section
      @user_group_section = current_user.user_group_sections.where(user_group_sections: { section: @post.section }).first
    end
  end
end
