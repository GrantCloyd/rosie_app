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
FactoryBot.define do
  factory :section_role_permission do
    section

    trait :default_subscriber do
      permission_level { :commenter_level }
      role_tier { :subscriber }
    end

    trait :default_moderator do
      permission_level { :moderator_level }
      role_tier { :moderator }
    end
  end
end
