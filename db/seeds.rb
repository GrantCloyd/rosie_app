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



users = users_seeds.map { |user_seed| User.first_or_create(user_seed) }

