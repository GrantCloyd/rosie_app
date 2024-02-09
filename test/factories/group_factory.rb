# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  slug       :string           not null
#  status     :integer          default("closed"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :group do
    title { 'Cool group' }
    slug { 'cool-group' }

    trait :open do
      status { :open }
    end
  end
end
