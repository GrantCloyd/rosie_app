# frozen_string_literal: true

require 'sidekiq/testing'

module Invites
  class CreatorServiceTest < ActiveSupport::TestCase
    let(:group) { create(:group) }
    let(:params) do
      { target_email: 'me@yo.com',
        role_tier: :subscriber,
        privacy_tier: :no_private_access }
    end
    let(:sender_name) { 'It Me' }
    subject { Invites::CreatorService.new(params:, group:, sender_name:) }

    describe '#call' do
      describe 'success' do
        it 'creates a new invite' do
          assert_difference 'Invite.count' do
            subject.call
          end
        end

        it 'returns a valid invite' do
          invite = subject.call

          assert invite.valid?
        end

        it 'triggers an invite mailer' do
          mailer = Minitest::Mock.new
          mail = Minitest::Mock.new

          GroupInviteMailer.expects(:with).once.returns(mailer)
          mailer.expect :invite_user, mail
          mail.expect :deliver_later, true

          subject.call
        end

        describe 'user_id behavior' do
          it 'has no user_id if target user does not exist' do
            invite = subject.call

            assert_nil invite.user_id
          end

          it 'attaches the user_id if the user already exist' do
            user = create(:user, email: 'me@yo.com')
            invite = subject.call

            assert_equal user.id, invite.user_id
          end
        end
      end

      describe 'failure' do
        let(:params) do
          { target_email: 'uhhh',
            role_tier: :subscriber,
            privacy_tier: :no_private_access }
        end

        it 'does not create a new invite' do
          assert_no_difference 'Invite.count' do
            subject.call
          end
        end

        it 'returns an invalid invite' do
          invite = subject.call

          assert invite.invalid?
          assert invite.errors.present?
        end

        it 'does not triggers an invite mailer' do
          GroupInviteMailer.expects(:with).never

          subject.call
        end
      end
    end
  end
end
