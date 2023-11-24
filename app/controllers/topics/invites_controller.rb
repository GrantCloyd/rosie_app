class Topics::InvitesController < Topics::BaseTopicsController
  before_action :ensure_logged_in
  before_action :set_topic
  before_action :ensure_user_authorized

  def new
    @invite = Invite.new
  end

  def create
    user = User.find_by(email: invite_params[:email])

    if user.present?
      @topic.invites.create!(invite_params.merge({user_id: user.id}))
    else
      @topic.invites.create!(invite_params)
    end

    redirect_to new_topic_invite_path(@topic.id), notice: "Invite sent!"

    rescue ActiveRecord::RecordInvalid  => error
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "#{error.message}"}
        format.html { render :new } 
      end
  end

  private

  def invite_params
    params.require(:invite).permit(:target_email, :invite_tier, :note)
  end
end
