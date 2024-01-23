# frozen_string_literal: true

require 'sidekiq/testing'

module Invites
  class AcceptServiceTest < ActiveSupport::TestCase
    describe '#call' do
      let(:invite) { create(:invite) }
      let(:subject) { Invites::AcceptService.new(invite:) }

      describe 'success' do
        it 'creates a new UserGroup' do
          assert_difference 'UserGroup.count' do
            subject.call
          end
        end

        it 'sets the invite to accepted' do
          subject.call
          assert_equal 'accepted', invite.status
        end

        it 'returns a valid user_group' do
          user_group = subject.call
          assert user_group.valid?
        end

        it 'calls associated jobs' do
          Invites::MemberJoinedNotificationJob.expects(:perform_later).with(invite.group_id, invite.user_id).once
          Invites::CreateUserGroupSectionsJob.expects(:perform_later).once
          subject.call
        end
      end

      describe 'failure' do
        let(:invite) { create(:invite) }
        before do
          invite.group_id = nil
        end
        let(:subject) { Invites::AcceptService.new(invite:) }

        it 'does not create a new UserGroup' do
          assert_no_difference 'UserGroup.count' do
            subject.call
          end
        end

        it 'does not set the invite to accepted' do
          subject.call
          assert_equal 'pending', invite.status
        end

        it 'returns an invalid user_group' do
          user_group = subject.call
          assert user_group.errors.present?
          assert user_group.invalid?
        end

        it 'does not call associated jobs' do
          Invites::MemberJoinedNotificationJob.expects(:perform_later).never
          Invites::CreateUserGroupSectionsJob.expects(:perform_later).never
          subject.call
        end
      end
    end
  end
end
