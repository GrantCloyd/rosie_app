# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/group_invite_mailer
class GroupInviteMailerPreview < ActionMailer::Preview
  def invite_user
    GroupInviteMailer.with(invite: Invite.first, sender_name: 'yoohoo@sailor.com').invite_user
  end

  def notify_group_creator
    GroupInviteMailer.with(group_creator_email: 'Maverick@topgun.com', group_title: 'Iceman sucks', new_user_full_name: 'Goose').notify_group_creator
  end
end
