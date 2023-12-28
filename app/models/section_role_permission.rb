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
class SectionRolePermission < ActiveRecord::Base
  belongs_to :section

  enum permission_level: UserGroupSection.permission_levels
  enum role_tier: UserGroup.roles

  DEFAULT_TIER_TO_PERMISSION_MAP = {
    moderator: :moderator_level,
    subscriber: :commenter_level
  }.freeze
end
