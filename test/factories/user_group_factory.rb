# frozen_string_literal: true

# == Schema Information
#
# Table name: user_groups
#
#  id           :bigint           not null, primary key
#  privacy_tier :integer          default("no_private_access"), not null
#  role         :integer          default("subscriber"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_user_groups_on_group_id              (group_id)
#  index_user_groups_on_user_id               (user_id)
#  index_user_groups_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :user_group do
    association :user
    association :group

    trait :creator do
      role { :creator }
    end

    trait :subscriber do
      role { :subscriber }
    end

    trait :moderator do
      role { :moderator }
    end

    trait :no_private_access do
      privacy_tier { :no_private_access }
    end

    trait :all_access do
      privacy_tier { :all_access }
    end

    trait :private_access do
      privacy_tier { :private_access }
    end
  end
end
