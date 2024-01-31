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
        let(:user_group) { create(:user_group, role: :subscriber) }
        let(:section) { create(:section, group: user_group.group) }
        let(:section_role_permission) { create(:section_role_permission, :default_subscriber, section:) }

        before { section_role_permission }

        it 'creates a new one' do
          assert_difference 'UserGroupSection.count' do
            subject.call
          end
        end
      end
    end
  end
end
