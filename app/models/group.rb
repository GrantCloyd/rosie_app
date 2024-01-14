# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  slug       :string           not null
#  status     :integer          default("closed"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Group < ActiveRecord::Base
  has_many :user_groups, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :posts, through: :sections

  before_validation :set_slug, only: %i[create update]

  enum status: {
    closed: 0,
    open: 1,
    archived: 2
  }

  validates :title, presence: true, length: { in: 3..150 }

  scope :in_order, lambda {
    order(created_at: :DESC)
  }

  def current_user_group(user)
    UserGroup.find_by(group: self, user:)
  end

  def last_post_time
    posts.published.in_order.first.created_at.strftime('%D')
  end

  def to_param
    "#{id}-#{slug}"
  end

  def last_sections_pin_index
    @last_sections_pin_index ||= sections.pinned.order(pin_index: :DESC).limit(1).pluck(:pin_index)&.first
  end

  private

  def set_slug
    self.slug = title.parameterize.to_s
  end
end
