# frozen_string_literal: true

# == Schema Information
#
# Table name: user_groups
#
#  id         :bigint           not null, primary key
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_groups_on_group_id              (group_id)
#  index_user_groups_on_user_id               (user_id)
#  index_user_groups_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  enum role: {
    subscriber: 0,
    moderator: 1,
    creator: 2
  }
end
