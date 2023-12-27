# frozen_string_literal: true

# == Schema Information
#
# Table name: user_group_sections
#
#  id               :bigint           not null, primary key
#  permission_level :integer          default("reader_level"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  section_id       :bigint           not null
#  user_group_id    :bigint           not null
#
# Indexes
#
#  index_user_group_sections_on_section_id                    (section_id)
#  index_user_group_sections_on_user_group_id                 (user_group_id)
#  index_user_group_sections_on_user_group_id_and_section_id  (user_group_id,section_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (user_group_id => user_groups.id)
#
class UserGroupSection < ApplicationRecord
  belongs_to :section
  belongs_to :user_group

  has_one :user, through: :user_group

  enum permission_level: {
    reader_level: 0,
    commenter_level: 1,
    contributor_level: 2,
    moderator_level: 3,
    creator_level: 4,
    blocked_level: 5
  }

  def self.current_user_group_section(user_group:, section:)
    find_by(user_group:, section:)
  end

  def moderator_or_creator?
    moderator_level? || creator_level?
  end

  def can_post?
    contributor_level? || moderator_or_creator?
  end

  def can_delete?
    moderator_or_creator?
  end

  def can_comment?
    !reader_level? || !blocked_level?
  end

  def can_view?
    !blocked_level?
  end
end
