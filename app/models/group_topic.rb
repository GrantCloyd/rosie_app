# == Schema Information
#
# Table name: group_topics
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  status      :integer          default(0), not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  group_id    :bigint           not null
#
# Indexes
#
#  index_group_topics_on_group_id  (group_id)
#
class GroupTopic < ActiveRecord::Base
end
