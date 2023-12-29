# frozen_string_literal: true

module PostsHelper
  def post_statuses_options
    select_option_generator(
      model: Post,
      plural_enum: :statuses
    )
  end

  def post_edited?(post)
    # because a post will get a timestamp with miliseconds of a difference between publish and updated
    post.published_on.strftime('%c') != post.updated_at.strftime('%c')
  end
end
