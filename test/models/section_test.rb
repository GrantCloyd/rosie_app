# frozen_string_literal: true

# == Schema Information
#
# Table name: sections
#
#  id           :bigint           not null, primary key
#  description  :text             not null
#  pin_index    :integer
#  privacy_tier :integer          default("open_tier"), not null
#  slug         :string           not null
#  status       :integer          default("unpublished"), not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_sections_on_group_id   (group_id)
#  index_sections_on_pin_index  (pin_index)
#  index_sections_on_status     (status)
#  index_sections_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  describe 'status change callback' do
    it 'does not trigger a callback when status or privacy tier is not updated' do
      section = create(:section, privacy_tier: :private_tier, pin_index: nil)
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:new).never
      section.update(pin_index: 0)
    end

    it 'does trigger a callback when the status is created as published' do
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).once

      create(:section, privacy_tier: :open_tier, status: :published)
    end

    it 'does not trigger a callback when the status is created as unpublished' do
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).never

      create(:section, privacy_tier: :open_tier, status: :unpublished)
    end

    it 'does trigger a callback when the status is changed to published' do
      section = create(:section, privacy_tier: :open_tier, status: :unpublished)
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).once
      section.update(status: :published)
    end

    it 'does trigger a callback when the privacy tier is updated' do
      section = create(:section, privacy_tier: :open_tier, status: :published)
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).once
      section.update(privacy_tier: :private_tier)
    end

    it 'does not trigger a callback when the status is created as unpublished' do
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).never

      create(:section, privacy_tier: :open_tier, status: :unpublished)
    end
  end
end
