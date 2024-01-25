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
      let(:target_emails) { 'words@aol.com dancermommy@gmail.com' }

      it 'when no errors are present returns only successes' do
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
        assert_empty subject.results[:errors]
        assert_equal 2, subject.results[:successes].count
      end
    end
  end
end
