# frozen_string_literal: true

# == Schema Information
#
# Table name: sections
#
#  id           :bigint           not null, primary key
#  description  :text             not null
#  pin_index    :integer
#  privacy_tier :integer          default("open_tier"), not null
#  slug         :string           not null
#  status       :integer          default("unpublished"), not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_sections_on_group_id   (group_id)
#  index_sections_on_pin_index  (pin_index)
#  index_sections_on_status     (status)
#  index_sections_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :section do
    association :user, strategy: :build
    association :group, strategy: :build
    title { 'Cool section' }
    status { :published }
    slug { "#{id}-#{title.parameterize}" }
  end
end
