# frozen_string_literal: true

# == Schema Information
#
# Table name: user_group_topics
#
#  id               :bigint           not null, primary key
#  permission_level :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  group_topic_id   :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_user_group_topics_on_group_topic_id              (group_topic_id)
#  index_user_group_topics_on_user_id                     (user_id)
#  index_user_group_topics_on_user_id_and_group_topic_id  (user_id,group_topic_id) UNIQUE
#
class UserGroupTopic < ActiveRecord::Base
end
