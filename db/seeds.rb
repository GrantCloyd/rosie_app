# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users_seeds = [
  {
    email: 'd@g.com',
    password: 'asd',
    role: :super_admin,
    full_name: 'd g'
  }
]

topics_seeds = [
  { data: {
      description: 'seed test',
      status: :closed,
      title: 'seed base'
    },
    posts_data: [{
      title: 'first',
      content: 'seed post info here',
      description: 'seeded yo',
      status: :pending
    },
                 {
                   title: 'second',
                   content: 'pub seed post',
                   description: 'pub seeded yo',
                   status: :published,
                   published_on: Date.current
                 }] }
]

users = users_seeds.map { |user_seed| User.first_or_create(user_seed) }

topics = topics_seeds.map do |topic_seed|
  topic = Topic.first_or_create(topic_seed[:data])

  topic_seed[:posts_data].each do |post_seed|
    topic.posts.create(post_seed)
  end
  topic
end

topics.each do |topic|
  users.each do |user|
    UserTopic.first_or_create({ topic:, user:, role: :moderator })
  end
end
