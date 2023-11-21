# == Schema Information
#
# Table name: user_preferences
#
#  id                             :bigint           not null, primary key
#  moderator_email_notifications  :boolean          default(TRUE)
#  subscriber_email_notifications :boolean          default(TRUE)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  user_id                        :bigint           not null
#
# Indexes
#
#  index_user_preferences_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UserPreference < ActiveRecord::Base

  belongs_to :user
end
