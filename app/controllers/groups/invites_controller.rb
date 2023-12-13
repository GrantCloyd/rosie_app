# frozen_string_literal: true

module Groups
  class InvitesController < Groups::BaseGroupsController
    before_action :set_mass_add_view_status, only: :new
    before_action :ensure_invitor_authorized

    def new; end

    def index
      @invites = @group.invites
    end

    def create
      invite = Invites::CreatorService.new(params: invite_params, group: @group).call

      if invite.errors.present?
        respond_to do |format|
          render_turbo_flash_alert(format, invite.errors.full_messages.to_sentence.to_s)
          format.html { render :new }
        end
      else
        redirect_to group_invites_path(@group.id)
      end
    end

    def mass_add
      # to do - make async
      mass_add_service = Invites::MassAddService.new(params: mass_add_params, group: @group)
      mass_add_service.call

      if mass_add_service.results[:errors].any?
        respond_to do |format|
          render_turbo_flash_alert(format, mass_add_service.display_error_messages.to_s)
          format.html { render :new }
        end
      else
        redirect_to new_group_invite_path(@group.id), notice: 'Invites sent!'
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
      params.permit(:target_emails, :role_tier, :note)
    end

    def ensure_invitor_authorized
      return if @user_group.moderator_or_creator?

      redirect_to request.referer, notice: 'Unauthorized'
    end
  end
end
