class Topics::InvitesController < Topics::BaseTopicsController
  before_action :ensure_logged_in
  before_action :set_topic
  before_action :set_mass_add_view_status, only: :new
  before_action :ensure_user_authorized

  def new
  end

  def create
    invite = Invites::CreatorService.new(params: invite_params, topic: @topic).call

    if invite.errors.present?
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "#{invite.errors.full_messages.to_sentence}"}
        format.html { render :new } 
      end 
    else
      redirect_to new_topic_invite_path(@topic.id), notice: "Invite sent!"
    end
     
  end

  def mass_add
    # to do - make async
    mass_add_service = Invites::MassAddService.new(params: mass_add_params, topic: @topic)
    mass_add_service.call
    
    if mass_add_service.results[:errors].any?
      respond_to do |format|
       format.html { render :new } 
       format.turbo_stream { flash.now[:alert] = "#{mass_add_service.display_error_messages}"}
      end
    else
      redirect_to new_topic_invite_path(@topic.id), notice: "Invites sent!"
    end
  end

  private

  def invite_params
    params.permit(:target_email, :invite_tier, :note)
  end

  def set_mass_add_view_status
    return @mass_add_view if defined?(@mass_add_view) 
    @mass_add_view ||= params[:mass_add_view].present? 
  end

  def mass_add_params
    params.permit(:target_emails, :invite_tier, :note)
  end
end