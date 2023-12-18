# frozen_string_literal: true

module Groups
  class InvitesController < Groups::BaseGroupsController
    before_action :set_mass_add_view_status, only: :new
    before_action :ensure_invitor_authorized, except: %i[accept reject]
    skip_before_action :ensure_user_authorized, only: %i[accept reject]

    def new; end

    def index
      @invites = @group.invites
    end

    def create
      invite = Invites::CreatorService.new(params: invite_params, group: @group, sender: current_user).call

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
      mass_add_service = Invites::MassAddService.new(params: mass_add_params, group: @group, sender: current_user)
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

    def edit
      @invite = Invite.find_by(id: params[:id])
    end

    def destroy
      @invite = Invite.find_by(id: params[:id])
      @invite.destroy

      respond_to do |format|
        format.turbo_stream { render 'groups/invites/streams/destroy' }
        format.html { render :index }
      end
    end

    def update
      @invite = Invite.find_by(id: params[:id])
      @invite.update(invite_params)

      redirect_to group_invites_path(@group)
    end

    def accept
      @invite = Invite.find_by(id: params[:id])

      @user_group = Invites::AcceptService.new(invite: @invite).call
      binding.pry

      if @user_group.errors.any?
        respond_to do |format|
          render_turbo_flash_alert(format, @user_group.errors.to_sentence)
          format.html { redirect_to groups_path }
        end
      else
        @group = @user_group.group
        
        respond_to do |format|
          format.turbo_stream { render 'groups/invites/streams/accept' }
          format.html { render 'groups/index' }
        end
      end
    end

    def reject
      @invite = Invite.find_by(id: params[:id])
    end

    private

    def invite_params
      params.permit(:target_email, :role_tier, :privacy_tier, :note)
    end

    def set_mass_add_view_status
      return @mass_add_view if defined?(@mass_add_view)

      @mass_add_view ||= params[:mass_add_view].present?
    end

    def mass_add_params
      params.permit(:target_emails, :role_tier, :privacy_tier, :note)
    end

    def ensure_invitor_authorized
      return if @user_group.moderator_or_creator?

      redirect_to request.referer, notice: 'Unauthorized'
    end
  end
end
