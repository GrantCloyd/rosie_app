# frozen_string_literal: true

module Topics
  class InvitesController < Topics::BaseTopicsController
    before_action :ensure_logged_in
    before_action :set_topic
    before_action :set_mass_add_view_status, only: :new
    before_action :ensure_user_authorized

    def new; end

    def create
      invite = Invites::CreatorService.new(params: invite_params, topic: @topic).call

      if invite.errors.present?
        respond_to do |format|
          render_turbo_flash_alert(format, invite.errors.full_messages.to_sentence.to_s)
          format.html { render :new }
        end
      else
        redirect_to new_topic_invite_path(@topic.id), notice: 'Invite sent!'
      end
    end

    def mass_add
      # to do - make async
      mass_add_service = Invites::MassAddService.new(params: mass_add_params, topic: @topic)
      mass_add_service.call

      if mass_add_service.results[:errors].any?
        respond_to do |format|
          render_turbo_flash_alert(format, mass_add_service.display_error_messages.to_s)
          format.html { render :new }
        end
      else
        redirect_to new_topic_invite_path(@topic.id), notice: 'Invites sent!'
      end
    end

    private

    def invite_params
      params.permit(:target_email, :invite_tier, :note)
    end

    def set_mass_add_view_status
      return @mass_add_view if defined?(@mass_add_view)

      @set_mass_add_view_status ||= params[:mass_add_view].present?
    end

    def mass_add_params
      params.permit(:target_emails, :invite_tier, :note)
    end
  end
end
