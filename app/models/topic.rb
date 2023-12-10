# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  status      :integer          default(0)
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  section_id  :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_topics_on_section_id  (section_id)
#  index_topics_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (user_id => users.id)
#
class Topic < ActiveRecord::Base
  belongs_to :section
  has_one :group, through: :section

  has_many :posts
  has_many :invites

  validates :title, length: { in: 3..120 }
  validates :description, length: { in: 3..250 }

  enum status: {
    closed: 0,
    open: 1,
    deactivated: 2
  }
end
