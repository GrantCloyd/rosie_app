# frozen_string_literal: true

# the intent is to reduce overall db hits
module UserReactions
  class CountPresenterService
    def initialize(user_reactions)
      @user_reactions = user_reactions
      @counter = Hash.new(0)
    end

    def count
      @user_reactions.each do |ur|
        @counter[ur.status] += 1
      end
      @counter.transform_keys { |k| k.pluralize.titleize }
    end
  end
end
