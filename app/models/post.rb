# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  content         :text             not null
#  description     :text             not null
#  published_on    :date
#  status          :integer          default("pending")
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  section_id      :bigint           not null
#  user_section_id :bigint           not null
#
# Indexes
#
#  index_posts_on_section_id       (section_id)
#  index_posts_on_user_section_id  (user_section_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (user_section_id => user_sections.id)
#
class Post < ActiveRecord::Base
  validates :content, :title, :description, :section_id, :user_section_id, presence: true

  belongs_to :section
  has_one :group, through: :section

  belongs_to :user_section
  has_one :user, through: :user_section

  has_many :comments, as: :commentable
  has_many :reactions, as: :reactionable

  enum status: {
    pending: 0,
    published: 1,
    hidden: 2
  }

  scope :in_order, lambda {
    order(:published_on, :created_at)
  }
end
