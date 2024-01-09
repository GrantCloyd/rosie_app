# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  pin_index    :integer
#  published_on :datetime
#  status       :integer          default("pending")
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  section_id   :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_pin_index   (pin_index)
#  index_posts_on_section_id  (section_id)
#  index_posts_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (user_id => users.id)
#

class Post < ActiveRecord::Base
  has_rich_text :content

  belongs_to :section
  has_one :group, through: :section

  belongs_to :user

  has_many :comments, as: :commentable
  has_many :user_reactions, as: :reactionable
  has_many_attached :images

  validates :images, content_type: %i[png jpg jpeg]
  validates :content, :title, :section_id, :user_id, presence: true

  before_save :resize_images_before_save

  enum status: {
    pending: 0,
    published: 1,
    hidden: 2
  }

  scope :in_order, lambda {
    order(:pin_index, :published_on, :created_at)
  }

  scope :hidden_or_pending, lambda {
    hidden.or(pending)
  }

  def display_published_or_created
    (published_on || created_at).strftime('%D %l:%m %P')
  end

  private

  def resize_images_before_save
    images.each do |image|
      next unless image.is_a?(ActionDispatch::Http::UploadedFile)
      next if image.persisted?

      ImageProcessing::MiniMagick
        .source(image)
        .resize_to_fit(1200)
    end
  end
end
