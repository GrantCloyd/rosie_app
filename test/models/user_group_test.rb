# frozen_string_literal: true

# == Schema Information
#
# Table name: user_groups
#
#  id           :bigint           not null, primary key
#  privacy_tier :integer          default("no_private_access"), not null
#  role         :integer          default("subscriber"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_user_groups_on_group_id              (group_id)
#  index_user_groups_on_user_id               (user_id)
#  index_user_groups_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class UserGroupTest < ActiveSupport::TestCase
  describe '#moderator_or_creator?' do
    it 'sucessfully checks expected roles' do
      user_group_creator = build(:user_group, role: :creator)
      user_group_moderator = build(:user_group, role: :moderator)
      [user_group_creator, user_group_moderator].each { |ug| assert ug.moderator_or_creator? }
    end

    it 'is false for non expected roles' do
      user_group_sub = build(:user_group, role: :subscriber)
      refute user_group_sub.moderator_or_creator?
    end
  end

  describe '#private_or_all_access?' do
    it 'successfuly checks privacy_tiers' do
      user_group_private = build(:user_group, privacy_tier: :private_access)
      user_group_all = build(:user_group, privacy_tier: :all_access)

      [user_group_private, user_group_all].each { |ug| assert ug.private_or_all_access? }
    end

    it 'is false for non expected privacy_tiers' do
      user_group_sub = build(:user_group, privacy_tier: :no_private_access)
      refute user_group_sub.private_or_all_access?
    end
  end
end
