class Topics::InvitationsController < Topics::BaseTopicsController
  before_action :ensure_logged_in
  before_action :set_topic
  before_action :ensure_user_authorized

  def new
    @invitation = Invitation.new
  end

  def create
    user = User.find_by(email: invitation_params[:email])
    
    if user.present?
      @topic.invitations.create!(invitation_params.merge({user_id: user.id}))
    else
      @topic.invitations.create!(invitation_params)
    end

    redirect_to new_topic_invitation_path(@topic.id), notice: "Invitation sent!"

    rescue ActiveRecord::RecordInvalid  => error
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "#{error.message}"}
        format.html { render :new } 
      end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:target_email, :invite_tier, :note)
  end
end
