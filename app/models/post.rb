# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  content      :text             not null
#  description  :text             not null
#  published_on :date
#  status       :integer          default("pending")
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  topic_id     :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_topic_id  (topic_id)
#  index_posts_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#
class Post < ActiveRecord::Base
  validates :content, :title, :description, :topic_id, presence: true

  has_one :topic

  has_one :user_section
  has_one :user, through: :user_section
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactionable

  enum status: {
    pending: 0,
    published: 1,
    hidden: 2
  }

  scope :in_order, lambda {
    order(:published_on, :created_at)
  }
end
