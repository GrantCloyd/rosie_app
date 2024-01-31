# frozen_string_literal: true

# == Schema Information
#
# Table name: section_role_permissions
#
#  id               :bigint           not null, primary key
#  permission_level :integer          not null
#  role_tier        :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  section_id       :bigint           not null
#
# Indexes
#
#  index_section_role_permissions_on_section_id                (section_id)
#  index_section_role_permissions_on_section_id_and_role_tier  (section_id,role_tier) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#
require 'test_helper'

class SectionRolePermissionTest < ActiveSupport::TestCase
  describe 'status change callback' do
    it 'does not trigger a callback when status is not updated' do
      srp = create(:section_role_permission, role_tier: :creator, permission_level: :creator_level)
      UserGroupSections::MassUpsertByRoleTierJob.expects(:perform_later).never
      srp.update(role_tier: :subscriber)
    end

    it 'does trigger a callback when the status is updated' do
      srp = create(:section_role_permission, role_tier: :creator, permission_level: :commenter_level)
      UserGroupSections::MassUpsertByRoleTierJob.expects(:perform_later).with(srp.section_id, srp.role_tier)
      srp.update(permission_level: :reader_level)
    end
  end
end
