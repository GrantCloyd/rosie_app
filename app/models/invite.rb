# frozen_string_literal: true

# == Schema Information
#
# Table name: invites
#
#  id           :bigint           not null, primary key
#  note         :text
#  role_tier    :integer          default(0)
#  status       :integer          default("pending")
#  target_email :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint
#
# Indexes
#
#  index_invites_on_group_id  (group_id)
#  index_invites_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class Invite < ActiveRecord::Base
  validates :target_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  belongs_to :topic
  belongs_to :user, optional: true

  enum status: {
    pending: 0,
    invited: 1,
    accepted: 2,
    rejected: 3
  }

  enum invite_tier: UserTopic.roles
end
