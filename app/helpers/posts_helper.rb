# frozen_string_literal: true

module PostsHelper
  def post_statuses_options
    Post.statuses.keys.map { |status| [status.titleize, status] }
  end
end
