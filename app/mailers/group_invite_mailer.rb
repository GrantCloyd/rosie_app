class GroupInviteMailer < ApplicationMailer
  default from: ENV.fetch('USER_EMAIL')
  after_action :update_invite_status

  def invite_user
    @invite = params[:invite]
    @email = @invite.target_email
    @group_title = @invite.group.title
    @note = @invite.note
    @sender_name = params[:sender_name]
    @url = 'http://localhost:3000/users/new'
    mail(to: @email, subject: "You've been invited!")
  end

  private

  def update_invite_status
    @invite.email_sent!
  end
end
