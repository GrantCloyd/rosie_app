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
class User < ActiveRecord::Base

  has_secure_password

  has_many :user_reactions
  has_many :user_topics
  has_one :user_preferences

  validates :email, uniqueness: true

  enum role: {
    general: 0, 
    admin: 1,
    super_admin: 2
  }

end
