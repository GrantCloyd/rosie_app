# == Schema Information
#
# Table name: topics
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  status      :integer          default("closed")
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Topic < ActiveRecord::Base
  
  has_one :creator, through: :user_topics
  
  has_many :posts
  has_many :invitations
  has_many :user_topics

  validates :title, length: {in: 3..120}
  validates :description, length: { in: 3..250 }

  enum status: {
    closed: 0, 
    open: 1,
    deactivated: 2
  }
end
