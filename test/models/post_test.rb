# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  pin_index    :integer
#  published_on :datetime
#  slug         :string           not null
#  status       :integer          default("pending")
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  section_id   :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_pin_index   (pin_index)
#  index_posts_on_section_id  (section_id)
#  index_posts_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  describe 'validations' do
    it 'checks for presence and fails if attributes are nil' do
      %w[title section_id user_id].each do |attr|
        post = build_stubbed(:post)
        post.send("#{attr}=", nil)
        assert post.invalid?
        assert_equal "#{attr.capitalize.gsub('_id', '')} can't be blank", post.errors.full_messages_for(attr.to_sym).first
      end
    end
  end

  describe 'callbacks' do
    it 'sets the slug on create' do
      post = create(:post, title: 'Dancing some yo')

      assert_equal 'dancing-some-yo', post.slug
    end
  end

  describe '#pending_or_hidden?' do
    it 'fails if published' do
      post = build_stubbed(:post, status: :published)

      refute post.pending_or_hidden?
    end

    it 'succeeds if pending or hidden' do
      %i[pending hidden].each do |status|
        assert build_stubbed(:post, status:).pending_or_hidden?
      end
    end

    describe '#display_published_or_created' do
      it 'displays published_on details if present' do
        published_on = DateTime.now - 1.day
        post = build_stubbed(:post, published_on:)

        assert_equal published_on.strftime('%D'), post.display_published_or_created
      end

      it 'displays created_at details if published is not present' do
        post = build_stubbed(:post, published_on: nil)

        assert_equal post.created_at.strftime('%D'), post.display_published_or_created
      end
    end
  end

  describe '#pinned?' do
    it 'is true if pin_index is present' do
      post = build_stubbed(:post, pin_index: 2)

      assert post.pinned?
    end

    it 'is false if pin_index is absent' do
      post = build_stubbed(:post, pin_index: nil)

      refute post.pinned?
    end
  end
end
