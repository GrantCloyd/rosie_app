# frozen_string_literal: true

module Groups
  class CreatorServiceTest < ActiveSupport::TestCase
    describe '#call' do
      let(:params) { { status: :closed, title: 'Cool party' } }
      let(:user) { create(:user, role: :super_admin) }
      subject { CreatorService.new(params:, user:) }

      describe 'success' do
        it 'creates a Group and UserGroup' do
          assert_difference 'UserGroup.count' do
            assert_difference 'Group.count' do
              subject.call
            end
          end
        end

        it 'returns a valid group' do
          group = subject.call
          assert_equal 'Group', group.class.name
          assert group.valid?
        end
      end

      describe 'failure' do
        let(:params) { { status: :closed, title: 'yo' } }
        it 'does not create a Group or UserGroup' do
          assert_no_difference 'UserGroup.count' do
            assert_no_difference 'Group.count' do
              subject.call
            end
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
