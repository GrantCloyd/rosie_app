# frozen_string_literal: true

# == Schema Information
#
# Table name: user_reactions
#
#  id                :bigint           not null, primary key
#  reactionable_type :string           not null
#  status            :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  reactionable_id   :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_user_reactions_on_reactionable  (reactionable_type,reactionable_id)
#  index_user_reactions_on_status        (status)
#  index_user_reactions_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UserReaction < ActiveRecord::Base
  belongs_to :user
  has_one :reactionable

  enum status: {
    like: 0,
    love: 1,
    celebrate: 2,
    laugh: 3
  }

  def format_status
    status.pluralize.titleize
  end
end
