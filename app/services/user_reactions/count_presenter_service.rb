# frozen_string_literal: true

# the intent is to reduce overall db hits
module UserReactions
  class CountPresenterService

    def initialize(user_reactions)
      @user_reactions = user_reactions
      # set a count dynamically to 0 and dynamically create readers
      UserReaction.statuses.each_key do |s| 
        pluralized_name = s.pluralize
        instance_variable_set("@#{pluralized_name}", 0)
        define_singleton_method("#{pluralized_name}") {
          instance_variable_get("@#{pluralized_name}")
        }
      end
    end

    def count
      @user_reactions.each do |ur| 
        reaction_count = instance_variable_get("@#{ur.status.pluralize}")
        instance_variable_set("@#{ur.status.pluralize}", (reaction_count + 1))
      end
    end
  end
end
