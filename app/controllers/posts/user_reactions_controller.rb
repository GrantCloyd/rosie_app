# frozen_string_literal: true

module Posts
  class UserReactionsController < Posts::BasePostsController
    def index
      user_reactions = UserReaction.includes(:user).where(reactionable_id: @post.id, reactionable_type: 'Post')
      @current_user_reaction = user_reactions.find_by(user_id: current_user.id)
      @reaction_counter = UserReactions::CountPresenterService.new(user_reactions).count
      render layout: false
    end

    def create
      @current_user_reaction = @post.user_reactions.create(reaction_params)
      @status = @current_user_reaction.format_status
      # we are only updating the counter for this reaction in the view
      # so other data can get stale - unlikely to matter to end user
      user_reactions = UserReaction.includes(:user).send(@current_user_reaction.status)
      @details = UserReactions::CountPresenterService.new(user_reactions).count[@status]

      respond_to do |format|
        format.turbo_stream { render 'posts/user_reactions/streams/create' }
        format.html { redirect_to group_section_post_path(current_group, @post.section, @post) }
      end
    end

    def destroy
      @reaction = UserReaction.find_by(id: params[:id])&.destroy
      @status = @reaction.format_status

      # doing this means the overall data the user is seeing could be stale - but unlikely to matter to end user
      # and prevents recalculating the entire reaction count
      @details = update_details_on_destroy(details_params)

      respond_to do |format|
        format.turbo_stream { render 'posts/user_reactions/streams/destroy' }
        format.html { redirect_to groups_sections_posts_show_path(current_group, @post.section, @post) }
      end
    end

    private

    def update_details_on_destroy(details)
      details[:count] = details[:count].to_i - 1

      return nil if details[:count].zero?

      details[:names] = details[:names].reject { |name| name == current_user.full_name }

      details
    end

    def details_params
      params['details'].permit!
    end

    def reaction_params
      params.permit(:status).merge({ user_id: current_user.id, reactionable_type: 'Post' })
    end
  end
end
