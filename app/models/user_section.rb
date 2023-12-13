# frozen_string_literal: true

# == Schema Information
#
# Table name: user_sections
#
#  id               :bigint           not null, primary key
#  permission_level :integer          default("reader"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  section_id       :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_user_sections_on_section_id              (section_id)
#  index_user_sections_on_user_id                 (user_id)
#  index_user_sections_on_user_id_and_section_id  (user_id,section_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (user_id => users.id)
#
class UserSection < ApplicationRecord
  belongs_to :section
  belongs_to :user

  enum permission_level: {
    reader: 0,
    commenter: 1,
    contributor: 2,
    moderator: 3,
    creator: 4,
    blocked: 5
  }

  def moderator_or_creator?
    moderator? || creator?
  end

  def can_post?
    contributor? || moderator_or_creator?
  end

  def can_delete?
    moderator_or_creator?
  end

  def can_comment?
    !reader? || !blocked?
  end

  def can_view?
    !blocked?
  end
end
