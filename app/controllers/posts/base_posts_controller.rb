# frozen_string_literal: true

module Posts
  class BasePostsController < ApplicationController
    before_action :set_post

    def set_post
      @post = Post.find(params[:post_id])
    end
  end
end
