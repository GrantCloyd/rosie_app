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
FactoryBot.define do
  factory :user_reaction do
    association :user
    reactionable_type { 'Post' }
    reactionable factory: :post
    status { :like }
  end
end
