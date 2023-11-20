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
  has_many :moderators, through: :user_topics
  has_many :subscribers, through: :user_topics

  enum status: {
    closed: 0, 
    open: 1,
    deactivated: 2
  }

  def self.creation_display_statuses
    statuses.except(:deactivated).keys.map {|status| [status.titleize, status]}
  end
end
