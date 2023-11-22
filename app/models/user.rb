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

  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, length: { in: 3..120 }
  validates :email, :full_name, :password_digest, presence: true

  has_secure_password
  
  has_one :user_preferences

  has_many :user_reactions
  has_many :user_topics
  has_many :invitations
 
  enum role: {
    general: 0, 
    admin: 1,
    super_admin: 2
  }

end
