# frozen_string_literal: true

module Groups
  class CreatorServiceTest < ActiveSupport::TestCase
    describe '#call' do
      let(:params) { { status: :closed, title: 'Cool party' } }
      let(:user) { create(:user, role: :super_admin) }
      subject { CreatorService.new(params:, user:) }

      describe 'success' do
        it 'creates a group' do
          assert_difference 'Group.count' do
            subject.call
          end
        end

        it 'creates a user_group' do
          assert_difference 'UserGroup.count' do
            subject.call
          end
        end

        it 'returns a group' do
          group = subject.call
          assert_equal 'Group', group.class.name
        end
      end

      describe 'failure' do
        let(:params) { { status: :closed, title: 'yo' } }
        it 'does not create a group' do
          assert_no_difference 'Group.count' do
            subject.call
          end
        end

        it 'does not create a user_group' do
          assert_no_difference 'UserGroup.count' do
            subject.call
          end
        end

        it 'returns the invalid group' do
          invalid_group = subject.call

          assert invalid_group.errors.present?
        end
      end
    end
  end
end
