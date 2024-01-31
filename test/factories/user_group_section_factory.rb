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
FactoryBot.define do
  factory :user_group_section do
    user_group
    section
    permission_level { :creator_level }
  end
end
