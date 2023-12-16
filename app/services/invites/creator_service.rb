# frozen_string_literal: true

module Invites
  class CreatorService
    def initialize(params:, group:, sender:)
      @params = params
      @group = group
      @sender = sender
      find_user_if_present
    end

    def call
      @invite = build_invite

      if @invite.valid?
        @invite.save!
        send_invite_email!
      end

      @invite
    end

    private

    def find_user_if_present
      return @user if defined?(@user)

      @user ||= User.find_by(email: @params[:target_email])
    end

    def build_invite
      if @user.present?
        @group.invites.new(@params.merge({ user_id: @user.id }))
      else
        @group.invites.new(@params)
      end
    end

    def send_invite_email!
      GroupInviteMailer.with(sender_name: @sender.full_name, invite: @invite).invite_user.deliver_later
    end
  end
end
