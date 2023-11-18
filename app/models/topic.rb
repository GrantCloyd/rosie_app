# == Schema Information
#
# Table name: topics
#
#  id            :bigint           not null, primary key
#  description   :text             not null
#  status        :integer          default(0)
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  moderator_id  :bigint
#  subscriber_id :bigint
#
# Indexes
#
#  index_topics_on_moderator_id   (moderator_id)
#  index_topics_on_subscriber_id  (subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (moderator_id => user_topics.id)
#  fk_rails_...  (subscriber_id => user_topics.id)
#
class Topic < ActiveRecord::Base
  
  has_many :posts
  has_many :moderators, through: :user_topics
  has_many :subscribers, through: :user_topics
end
