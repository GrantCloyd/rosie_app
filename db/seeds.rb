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
  },
  {
    email: 'd2@g.com',
    password: 'asd',
    role: :general,
    full_name: 'd 2g'
  }
]

groups_seeds = [{
  title: "Test seed",
  status: :closed
}]


users = users_seeds.map { |user_seed| User.create(user_seed) }
groups = groups_seeds.map {|group_seed|  Group.create(group_seed) }

users.each do |user| 
  groups.each do |group|
  if user.super_admin?
    UserGroup.create(user_id: user.id, group_id: group.id, role: :creator, privacy_tier: :all_access)
  else
    UserGroup.create(user_id: user.id, group_id: group.id, role: :subscriber, privacy_tier: :no_private_access)
    end
  end
end

