# frozen_string_literal: true

module Invites
  class MassAddServiceTest < ActiveSupport::TestCase
    let(:group) { create(:group) }
    let(:sender_name) { 'This Guy' }
    let(:params) do
      { target_emails:,
        role_tier: :subscriber,
        privacy_tier: :no_private_access,
        note: nil }
    end

    subject { MassAddService.new(params:, group:, sender_name:) }

    describe '#create_invites' do
      describe 'no errors are present' do
        let(:target_emails) { 'words@aol.com dancermommy@gmail.com' }

        it 'returns only successes' do
          target_emails.split.each do |target_email|
            invite = build_stubbed(:invite, target_email:)
            invite_service = Minitest::Mock.new
            Invites::CreatorService.expects(:new)
                                   .with(
                                     params: params.except(:target_emails).merge({ target_email: }),
                                     group:,
                                     sender_name:
                                   )
                                   .returns(invite_service)
            invite_service.expect :call, invite
          end

          subject.create_invites
          assert_empty subject.errors
          assert_equal 2, subject.successes.count
        end
      end

      describe 'only errors are present' do
        let(:target_emails) { 'oopsididntdoitright sosowrongemail' }
        it 'returns only failures and displays expected error message' do
          target_emails.split.each do |target_email|
            invite = build_stubbed(:invite, target_email:)
            # trigger error message on stubbed invite
            invite.valid?
            invite_service = Minitest::Mock.new
            Invites::CreatorService.expects(:new)
                                   .with(
                                     params: params.except(:target_emails).merge({ target_email: }),
                                     group:,
                                     sender_name:
                                   )
                                   .returns(invite_service)
            invite_service.expect :call, invite
          end

          subject.create_invites
          assert_equal 2, subject.errors.count
          assert_empty subject.successes
          assert_equal "** Invite for oopsididntdoitright could not be sent: Target email is invalid\n\n** Invite for sosowrongemail could not be sent: Target email is invalid",
                       subject.display_error_messages
        end
      end

      describe 'errors and successes are present' do
        let(:target_emails) { 'oopsididntdoitright sosowrightemail@gmail.com' }
        it 'returns both successes and failures and displays expected error message' do
          target_emails.split.each do |target_email|
            invite = build_stubbed(:invite, target_email:)
            # trigger error message on stubbed invite
            invite.valid?
            invite_service = Minitest::Mock.new
            Invites::CreatorService.expects(:new)
                                   .with(
                                     params: params.except(:target_emails).merge({ target_email: }),
                                     group:,
                                     sender_name:
                                   )
                                   .returns(invite_service)
            invite_service.expect :call, invite
          end

          subject.create_invites
          assert_equal 1, subject.errors.count
          assert_equal 1, subject.successes.count
          assert_equal '** Invite for oopsididntdoitright could not be sent: Target email is invalid',
                       subject.display_error_messages
        end
      end
    end
  end
end
