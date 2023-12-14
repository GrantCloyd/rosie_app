class GroupInviteMailer < ApplicationMailer
  default from: 'dgcloyd@gmail.com'

  def invite_user
    @email = params[:email]
    @group = params[:group]
    @sender_name = params[:sender_name]
    @note = params[:note]
    @url = 'localhost:3000'
    mail(to: @email, subject: "You've been invited!")
  end
end
