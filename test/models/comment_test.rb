# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  commentable_type :string           not null
#  content          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#  index_comments_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  describe 'validations' do
    it 'validates content present' do
      empty_comment = build(:comment, content: nil)
      assert empty_comment.invalid?
      assert empty_comment.errors.full_messages_for(:content).include?("Content can't be blank")
    end

    it 'validates content greater than three characters' do
      short_comment = build(:comment, content: 'Yo')
      assert short_comment.invalid?
      assert short_comment.errors.full_messages_for(:content).include?('Content is too short (minimum is 3 characters)')
    end
  end
end
