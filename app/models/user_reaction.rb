# == Schema Information
#
# Table name: user_reactions
#
#  id                :bigint           not null, primary key
#  reaction_status   :integer          not null
#  reactionable_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  reactionable_id   :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_user_reactions_on_reactionable  (reactionable_type,reactionable_id)
#  index_user_reactions_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UserReaction < ActiveRecord::Base
  
  has_one :user 
  has_one :reactionable

  enum reaction_status: {
    like: 0, 
    love: 1, 
    care: 2, 
    thank: 3
  }
end
