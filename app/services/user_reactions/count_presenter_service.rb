# frozen_string_literal: true

# the intent is to reduce overall db hits - but this could be moved to
# a jsonb column pre-calculated on the post to reduce load time

# TODO : benchmarking and determining how slow this will be on an individual page at larger scale
module UserReactions
  class CountPresenterService
    def initialize(user_reactions)
      @user_reactions = user_reactions
      @counter = Hash.new { |hash, key| hash[key] = { names: [], count: 0 } }
    end

    def count
      @user_reactions.each do |ur|
        key = ur.format_status
        @counter[key][:count] += 1
        @counter[key][:names] << ur.user.full_name
      end
      @counter
    end
  end
end
