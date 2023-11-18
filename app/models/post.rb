# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  description :text             not null
#  status      :integer          default(0)
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  topics_id   :bigint
#
# Indexes
#
#  index_posts_on_topics_id  (topics_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (topics_id => topics.id)
#
class Post < ActiveRecord::Base
  
  has_one :topic
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactionable 
end
