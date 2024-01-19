# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  pin_index    :integer
#  published_on :datetime
#  slug         :string           not null
#  status       :integer          default("pending")
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  section_id   :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_pin_index   (pin_index)
#  index_posts_on_section_id  (section_id)
#  index_posts_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    user
    section
    title { 'Cool Post' }
    slug { 'cool-post' }

    trait :with_image do
      after(:build) do |post|
        post.images.attach(
          io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test.jpg')),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
