# frozen_string_literal: true

# == Schema Information
#
# Table name: sections
#
#  id           :bigint           not null, primary key
#  description  :text             not null
#  privacy_tier :integer          default("open_tier"), not null
#  status       :integer          default("unpublished"), not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#
# Indexes
#
#  index_sections_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
class Section < ActiveRecord::Base
  belongs_to :group
  has_many :posts, dependent: :destroy
  has_many :user_group_sections, dependent: :destroy

  enum status: {
    unpublished: 0,
    published: 1,
    hidden: 2
  }

  enum privacy_tier: {
    open_tier: 0,
    private_tier: 1,
    manual_only_tier: 2
  }

  scope :hidden_or_unpublished, lambda {
    hidden.or(unpublished)
  }

  scope :in_order, lambda {
    order(created_at: :DESC)
  }
end
