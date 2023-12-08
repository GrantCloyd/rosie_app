# frozen_string_literal: true

# == Schema Information
#
# Table name: sections
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
#  index_sections_on_group_id  (group_id)
#
class Section < ActiveRecord::Base
  belongs_to :group
  has_many :topics
end
