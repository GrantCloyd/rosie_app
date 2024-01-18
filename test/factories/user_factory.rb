# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  full_name       :string           not null
#  password_digest :string           not null
#  role            :integer          default("general")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    full_name { 'Cool Person' }
    password_digest { 'sosecret' }
    sequence(:email) { |n| "yo#{n}@me.com" }
    role { :super_admin }
  end
end
