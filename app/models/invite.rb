# frozen_string_literal: true

# == Schema Information
#
# Table name: invites
#
#  id           :bigint           not null, primary key
#  note         :text
#  privacy_tier :integer          default("no_private_access")
#  role_tier    :integer          default("subscriber")
#  status       :integer          default("pending")
#  target_email :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint
#
# Indexes
#
#  index_invites_on_group_id                   (group_id)
#  index_invites_on_status                     (status)
#  index_invites_on_target_email_and_group_id  (target_email,group_id) UNIQUE
#  index_invites_on_user_id                    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class Invite < ActiveRecord::Base
  belongs_to :group
  belongs_to :user, optional: true

  before_save :strip_note_if_empty

  validates :target_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :target_email, uniqueness: { scope: :group_id }

  enum status: {
    pending: 0,
    email_sent: 1,
    accepted: 2,
    rejected: 3
  }

  scope :pending_or_email_sent, lambda {
    pending.or(email_sent)
  }

  enum role_tier: UserGroup.roles

  enum privacy_tier: UserGroup.privacy_tiers

  def strip_note_if_empty
    self.note = nil if note && note.empty?
  end

  def can_edit?
    pending? || email_sent?
  end
end
