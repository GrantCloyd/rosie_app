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
require 'test_helper'

class UserGroupSectionTest < ActiveSupport::TestCase
  describe 'permission methods' do
    describe '#moderator_or_creator?' do
      it 'is valid if level matches' do
        permission_levels = %i[moderator_level creator_level]

        ug_secs = permission_level_generator(select_array: permission_levels)
        ug_secs.each { |ugs| assert ugs.moderator_or_creator? }
      end
      it 'is not valid for other permission levels' do
        permission_levels = %i[creator_level moderator_level]

        ug_secs = permission_level_generator(except_array: permission_levels)
        ug_secs.each { |ugs| refute ugs.moderator_or_creator? }
      end
    end

    describe '#can_post?' do
      it 'is valid if level matches' do
        permission_levels = %i[moderator_level creator_level contributor_level]

        ug_secs = permission_level_generator(select_array: permission_levels)
        ug_secs.each { |ugs| assert ugs.can_post? }
      end
      it 'is not valid for other permission levels' do
        permission_levels = %i[moderator_level creator_level contributor_level]

        ug_secs = permission_level_generator(except_array: permission_levels)
        ug_secs.each { |ugs| refute ugs.can_post? }
      end
    end

    describe '#can_comment?' do
      it 'is valid if level matches' do
        permission_levels = %i[reader_level blocked_level]

        ug_secs = permission_level_generator(except_array: permission_levels)
        ug_secs.each { |ugs| assert ugs.can_comment? }
      end
      it 'is not valid for other permission levels' do
        permission_levels = %i[reader_level blocked_level]

        ug_secs = permission_level_generator(select_array: permission_levels)
        ug_secs.each { |ugs| refute ugs.can_comment }
      end
    end
  end

  private

  def permission_level_generator(select_array: nil, except_array: nil)
    if select_array.present?
      UserGroupSection.permission_levels.select do |k, _v|
        select_array.include?(k)
      end.keys.map { |permission_level| build_stubbed(:user_group_section, permission_level:) }
    else
      UserGroupSection.permission_levels.except(*except_array).keys.map { |permission_level| build_stubbed(:user_group_section, permission_level:) }
    end
  end
end
