# frozen_string_literal: true

require 'test_helper'

module UserGroupSections
  class CreateOrFindServiceTest < ActiveSupport::TestCase
    subject { UserGroupSections::CreateOrFindService.new(user_group:, section:) }

    describe '#call' do
      describe 'when user_group_section already exists' do
        let(:user_group_section) { create(:user_group_section) }
        let(:user_group) { user_group_section.user_group }
        let(:section) { user_group_section.section }

        before { user_group_section }

        it 'returns the already created user_group_section' do
          result = subject.call
          assert_equal user_group_section, result
        end

        it 'does not create a new user_group_section' do
          assert_no_difference 'UserGroupSection.count' do
            subject.call
          end
        end
      end

      describe 'when user_group_section does not exist' do
        describe 'when section is open and user does not have private access' do
          let(:user_group) { create(:user_group, role: :subscriber, privacy_tier: :no_private_access) }
          let(:section) { create(:section, privacy_tier: :open_tier, group: user_group.group) }
          let(:section_role_permission) { create(:section_role_permission, :default_subscriber, section:) }

          before { section_role_permission }

          it 'creates a new user_group_section' do
            assert_difference 'UserGroupSection.count' do
              subject.call
            end
          end

          it 'returns the user_group_section, sets permissions to the expected level, and attaches the correct associations' do
            user_group_section = subject.call

            assert_equal 'commenter_level', user_group_section.permission_level
            assert_equal section, user_group_section.section
            assert_equal user_group, user_group_section.user_group
          end

          it 'subsequent calls return the same object' do
            newly_created_user_group_section = subject.call
            subsequent_call_user_group_section = subject.call

            assert_equal newly_created_user_group_section,
                         subsequent_call_user_group_section
          end
        end

        describe 'when section is closed and user does not have private access' do
          let(:user_group) { create(:user_group, role: :subscriber, privacy_tier: :no_private_access) }
          let(:section) { create(:section, privacy_tier: :private_tier, group: user_group.group) }
          let(:section_role_permission) { create(:section_role_permission, :default_subscriber, section:) }

          it 'creates a new user_group_section' do
            assert_difference 'UserGroupSection.count' do
              subject.call
            end
          end

          it 'creates a blocked user_group_section' do
            user_group_section = subject.call

            assert_equal 'blocked_level', user_group_section.permission_level
          end
        end

        describe 'when user_group is creator level and no creator permission level exists' do
          let(:user_group) { create(:user_group, role: :creator, privacy_tier: :all_access) }
          let(:section) { create(:section, privacy_tier: :private_tier, group: user_group.group) }

          it 'creates a new user_group_section' do
            assert_difference 'UserGroupSection.count' do
              subject.call
            end
          end

          it 'creates a creator level user_group_section' do
            user_group_section = subject.call

            assert_equal 'creator_level', user_group_section.permission_level
          end
        end

        describe 'when section is private and user has private access' do
          let(:user_group) { create(:user_group, role: :subscriber, privacy_tier: :private_access) }
          let(:section) { create(:section, privacy_tier: :private_tier, group: user_group.group) }
          let(:section_role_permission) { create(:section_role_permission, :default_subscriber, section:) }

          before { section_role_permission }

          it 'creates a the expected permission level user_group_section' do
            user_group_section = subject.call

            assert_equal 'commenter_level', user_group_section.permission_level
          end
        end

        describe 'when user is a moderator, section is private and user_group has private access' do
          let(:user_group) { create(:user_group, role: :moderator, privacy_tier: :private_access) }
          let(:section) { create(:section, privacy_tier: :private_tier, group: user_group.group) }
          let(:section_role_permission) { create(:section_role_permission, :default_moderator, section:) }

          before { section_role_permission }

          it 'creates a the expected permission level user_group_section' do
            user_group_section = subject.call

            assert_equal 'moderator_level', user_group_section.permission_level
          end
        end

        describe 'when section is manual only and user has private access' do
          let(:user_group) { create(:user_group, role: :subscriber, privacy_tier: :private_access) }
          let(:section) { create(:section, privacy_tier: :manual_only_tier, group: user_group.group) }
          let(:section_role_permission) { create(:section_role_permission, :default_subscriber, section:) }

          before { section_role_permission }

          it 'creates a blocked permission level user_group_section' do
            user_group_section = subject.call

            assert_equal 'blocked_level', user_group_section.permission_level
          end
        end

        describe 'when section is manual only and user has all access' do
          let(:user_group) { create(:user_group, role: :subscriber, privacy_tier: :all_access) }
          let(:section) { create(:section, privacy_tier: :manual_only_tier, group: user_group.group) }
          let(:section_role_permission) { create(:section_role_permission, :default_subscriber, section:) }

          before { section_role_permission }

          it 'creates a blocked permission level user_group_section' do
            user_group_section = subject.call

            assert_equal 'commenter_level', user_group_section.permission_level
          end
        end

        describe 'when section is private and user has private access but no section role permission exists' do
          let(:user_group) { create(:user_group, role: :subscriber, privacy_tier: :private_access) }
          let(:section) { create(:section, privacy_tier: :private_tier, group: user_group.group) }

          it 'creates a default reader permission level user_group_section' do
            user_group_section = subject.call

            assert_equal 'reader_level', user_group_section.permission_level
          end
        end
      end
    end
  end
end
