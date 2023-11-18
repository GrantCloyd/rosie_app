# == Schema Information
#
# Table name: user_topics
#
#  id         :bigint           not null, primary key
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_topics_on_topic_id  (topic_id) UNIQUE
#  index_user_topics_on_user_id   (user_id) UNIQUE
#
class UserTopics < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic

  enum role: {
    subscriber: 0,
    moderator: 1 
  }
end
