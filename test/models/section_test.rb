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
    it 'triggers a callback when the status is created as published' do
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).once

      create(:section, privacy_tier: :open_tier, status: :published)
    end

    it 'triggers a callback when the status is changed to published' do
      section = create(:section, privacy_tier: :open_tier, status: :unpublished)
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).once
      section.update(status: :published)
    end

    it 'triggers a callback when the privacy tier is updated' do
      section = create(:section, privacy_tier: :open_tier, status: :published)
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).once
      section.update(privacy_tier: :private_tier)
    end

    it 'does not trigger a callback when status or privacy tier is not updated' do
      section = create(:section, privacy_tier: :private_tier, pin_index: nil)
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:new).never
      section.update(pin_index: 0)
    end

    it 'does not trigger a callback when the status is created as unpublished' do
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).never

      create(:section, privacy_tier: :open_tier, status: :unpublished)
    end

    it 'does not trigger a callback when the status is created as unpublished' do
      Sections::CreateOrUpdateUserGroupSectionsService.any_instance.expects(:call).never

      create(:section, privacy_tier: :open_tier, status: :unpublished)
    end
  end

  describe '#last_posts_pin_index' do
    it 'returns nil if none are present' do
      section = build_stubbed(:section)

      assert_nil section.last_posts_pin_index
    end

    it 'returns the last pin_index when present' do
      section = create(:section)
      create_list(:post, 3, section:) do |post, idx|
        post.update(pin_index: idx)
      end

      assert_equal 2, section.last_posts_pin_index
    end
  end

  describe '#any_posts_pinned?' do
    it 'is false if no posts are present' do
      section = build_stubbed(:section)

      refute section.any_posts_pinned?
    end

    it 'is false if any are present but no pin index exists' do
      section = create(:section)
      create(:post, section:)

      refute section.any_posts_pinned?

      refute section.any_posts_pinned?
    end

    it 'is true if any are present and a pin index exists' do
      section = create(:section)
      create(:post, section:, pin_index: 0)

      assert section.any_posts_pinned?
    end
  end

  describe '#hidden_or_unpublished?' do
    it 'succeeds when the expected status is present' do
      sections_with_expected_status = %i[unpublished hidden].map do |status|
        build_stubbed(:section, status:)
      end

      sections_with_expected_status.each { |sec| assert sec.unpublished_or_hidden? }
    end

    it 'fails when the section is published' do
      refute build_stubbed(:section, status: :published).unpublished_or_hidden?
    end
  end
end
