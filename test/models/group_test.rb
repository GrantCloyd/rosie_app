# frozen_string_literal: true

require 'test_helper'
require 'sidekiq/testing'

class GroupTest < ActiveSupport::TestCase
  describe 'callbacks' do
    it 'generates a slug on create' do
      group = create(:group, title: 'Welcome folks to this')
      assert_equal 'welcome-folks-to-this', group.slug
    end
  end

  describe 'validations' do
    it 'validates title presence' do
      empty_title_group = build_stubbed(:group, title: nil)
      assert empty_title_group.invalid?
      assert empty_title_group.errors.full_messages_for(:title).include?("Title can't be blank")
    end

    it 'validates content greater than three characters' do
      short_title_group = build_stubbed(:group, title: 'Yo')
      assert short_title_group.invalid?
      assert short_title_group.errors.full_messages_for(:title).include?('Title is too short (minimum is 3 characters)')
    end
  end

  describe '#last_post_time' do
    it 'accurately finds the last post when one is present' do
      group = create(:group)
      binding.pry
      user = create(:user, email: 'rando@a.com')
      section = create(:section, group:, user:)
      published_time = DateTime.now - 1.day
      create(:post, user:, section:, status: :published, published_on: published_time, content: 'no to you')

      assert_equal published_time.strftime('%D'), group.last_post_time
    end
  end
end
