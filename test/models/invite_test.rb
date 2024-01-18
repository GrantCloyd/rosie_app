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
require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  describe '#strip_note_if_empty' do
    it 'sets note to nil if passed an empty string' do
      invite = create(:invite, note: '')

      assert_nil invite.note
    end
  end

  describe '#can_edit?' do
    it 'correctly passes for pending or email sent' do
      invite_pending = build_stubbed(:invite, status: :pending)
      invite_sent = build_stubbed(:invite, status: :email_sent)
      [invite_pending, invite_sent].each { |i| assert i.can_edit? }
    end

    it 'correctly fails for accepted or rejected' do
      invite_accepted = build_stubbed(:invite, status: :accepted)
      invite_rejected = build_stubbed(:invite, status: :rejected)
      [invite_accepted, invite_rejected].each { |i| refute i.can_edit? }
    end
  end
end
