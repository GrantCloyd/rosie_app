# frozen_string_literal: true

# if pin_index is also added to section consider refactor

# the pin_index is zero indexed so a 'high' index will display
# after (or below) a 'low' index in the view layer
module Posts
  class SwapPinIndexService
    def initialize(high_index: nil, low_index: nil)
      # reminder these are input values and not the end result
      @high_index = high_index
      @low_index = low_index
    end

    def call
      return unless @high_index.nil? || @low_index.nil?

      swap_index = @high_index.present? ? @high_index.pin_index - 1 : @low_index.pin_index + 1
      swap_post = Post.find_by(pin_index: swap_index)

      return unless swap_post.present?

      new_low_index, new_high_index = if @high_index.present?
                                        swap(@high_index, swap_post, swap_index)
                                      else
                                        swap(@low_index, swap_post, swap_index).reverse
                                      end

      [new_low_index, new_high_index].each(&:save)
    end

    private

    def swap(original, swap_post, swap_index)
      swap_post.pin_index = original.pin_index
      original.pin_index = swap_index
      [original, swap_post]
    end
  end
end
