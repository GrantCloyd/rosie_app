# frozen_string_literal: true

# == Schema Information
#
# Table name: sections
#
#  id           :bigint           not null, primary key
#  description  :text             not null
#  pin_index    :integer
#  privacy_tier :integer          default("open_tier"), not null
#  slug         :string           not null
#  status       :integer          default("unpublished"), not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_sections_on_group_id   (group_id)
#  index_sections_on_pin_index  (pin_index)
#  index_sections_on_status     (status)
#  index_sections_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class Section < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :user_group_sections, dependent: :destroy
  has_many :section_role_permissions, dependent: :destroy

  accepts_nested_attributes_for :section_role_permissions

  after_save :upsert_user_group_sections, if: :status_change_affects_user_group_sections?

  validates :title, presence: true, length: { in: 3..80 }
  validates :description, presence: true, length: { in: 3..125 }

  before_validation :set_slug, only: %i[create update]

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
    order(:pin_index, created_at: :DESC)
  }

  scope :pinned, lambda {
    where.not(pin_index: nil)
  }

  def last_posts_pin_index
    return @last_posts_pin_index if defined?(@last_posts_pin_index)

    @last_posts_pin_index ||= posts.pinned.order(pin_index: :DESC).limit(1).pluck(:pin_index)&.first
  end

  def unpublished_or_hidden?
    unpublished? || hidden?
  end

  def pinned?
    pin_index.present?
  end

  def to_param
    "#{id}-#{slug}"
  end

  def any_posts_pinned?
    return @any_posts_pinned if defined?(@any_posts_pinned)

    @any_posts_pinned ||= posts.where.not(pin_index: nil).limit(1).present?
  end

  private

  # will fire after update, publish, or create
  def upsert_user_group_sections
    Sections::CreateOrUpdateUserGroupSectionsService.new(self).call
  end

  def status_change_affects_user_group_sections?
    (saved_change_to_status? && status == 'published') ||
      saved_change_to_privacy_tier
  end

  def set_slug
    self.slug = title.parameterize.to_s
  end
end
