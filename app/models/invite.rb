# == Schema Information
#
# Table name: invites
#
#  id           :bigint           not null, primary key
#  invite_tier  :integer          default("subscriber")
#  note         :text
#  status       :integer          default("pending")
#  target_email :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  topic_id     :bigint           not null
#  user_id      :bigint
#
# Indexes
#
#  index_invites_on_topic_id  (topic_id)
#  index_invites_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#
class Invite < ActiveRecord::Base
  
  validates :target_email, format: {with: URI::MailTo::EMAIL_REGEXP }

  belongs_to :topic
  belongs_to :user, optional: true

  enum status: {
    pending: 0,
    invited: 1,
    accepted: 2, 
    rejected: 3 
  }

  enum invite_tier: UserTopic.roles
end
