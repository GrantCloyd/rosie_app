# frozen_string_literal: true

# == Schema Information
#
# Table name: invites
#
#  id           :bigint           not null, primary key
#  note         :text
#  privacy_tier :integer          default("no_private_access")
#  role_tier    :integer          default("subscriber")
#  status       :integer          default("pending")
#  target_email :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint
#
# Indexes
#
#  index_invites_on_group_id                   (group_id)
#  index_invites_on_status                     (status)
#  index_invites_on_target_email_and_group_id  (target_email,group_id) UNIQUE
#  index_invites_on_user_id                    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :invite do
    association :user
    association :group
    target_email { 'notyo@me.com' }
    note { 'Join this cool group notyo' }
  end
end
