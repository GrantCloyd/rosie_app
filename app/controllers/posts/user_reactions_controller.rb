# frozen_string_literal: true

module Posts
  class UserReactionsController < Posts::BasePostsController
    def create
      @reaction = @post.user_reactions.create(reaction_params)

      # respond_to do |format|
      # TO DO format.turbo_stream { render 'posts/reactions/streams/create' }
      #   format.html { redirect_to group_section_post_path(current_group, @post.section, @post) }
      # end
    end

    def destroy
      @reaction = UserReaction.find_by(id: params[:id])&.destroy

      # respond_to do |format|
        #TO DO format.turbo_stream { render 'posts/reactions/streams/destroy' }
        # format.html { redirect_to groups_sections_posts_show_path(current_group, @post.section, @post) }
      # end
    end

    private

    def reaction_params
      params.permit(:status).merge({ user_id: current_user.id, reactionable_type: 'Post' })
    end
  end
end
