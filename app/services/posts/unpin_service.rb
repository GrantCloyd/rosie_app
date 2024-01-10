# frozen_string_literal: true

module Posts
  class UnpinService
    # might need to make this into a background service if it adds too much time
    # current usage does not envision having a ton of pinned posts so it should be negligible for the moment

    def initialize(post:, section:)
      @post = post
      @section = section
      @current_pin_index = post.pin_index
    end

    def call
      remove_post_pin_index
      reindex_section_pin_indices
    end

    private

    def remove_post_pin_index
      @post.update(pin_index: nil)
    end

    def reindex_section_pin_indices
      # all pinned items high_indexer than current
      posts = @section.posts.where(pin_index: @current_pin_index..).order(:pin_index)

      posts.to_a.each.with_index(@current_pin_index) do |post, indx|
        post.update(pin_index: indx)
      end
    end
  end
end
