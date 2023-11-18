# == Schema Information
#
# Table name: invitations
#
#  id           :bigint           not null, primary key
#  note         :text
#  status       :integer          default(0)
#  target_email :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  topic_id     :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_invitations_on_topic_id  (topic_id) UNIQUE
#  index_invitations_on_user_id   (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#
class Invitation < ActiveRecord::Base
  
  validates :target_email, format: {with: URI::MailTo::EMAIL_REGEXP }

  belongs_to :topic
  
  has_one :user, optional: true

  enum status: {
    pending: 0,
    invited: 1,
    accepted: 2, 
    rejected: 3 
  }
end
