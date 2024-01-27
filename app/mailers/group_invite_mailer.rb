# frozen_string_literal: true

class GroupInviteMailer < ApplicationMailer
  default from: ENV.fetch('SMTP_EMAIL')
  after_action :update_invite_status, only: [:invite_user]

  def invite_user
    @invite = params[:invite]
    @email = @invite.target_email
    @group_title = @invite.group.title
    @note = @invite.note
    @sender_name = params[:sender_name]
    @url = "#{ENV.fetch('BASE_URL', nil)}/users/new"
    mail(to: @email, subject: "You've been invited!")
  end

  def notify_group_creator
    @group_creator_email = params[:group_creator_email]
    @group_title = params[:group_title]
    @new_user_full_name = params[:new_user_full_name]
    mail(to: @group_creator_email, subject: 'A new member has joined your group')
  end

  private

  def update_invite_status
    @invite.email_sent!
  end
end
