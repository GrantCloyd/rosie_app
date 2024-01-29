# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  expires_at :datetime         not null
#  kind       :integer          not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tokens_on_code              (code) UNIQUE
#  index_tokens_on_expires_at        (expires_at)
#  index_tokens_on_kind_and_user_id  (kind,user_id) UNIQUE
#  index_tokens_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Token < ApplicationRecord
  belongs_to :user
  validates :code, length: { is: 36 }

  enum kind: {
    authentication: 0,
    recovery: 1
  }

  DEFAULT_EXPIRATION_TIMES = {
    authentication: 1.day,
    recovery: 15.minutes
  }.with_indifferent_access.freeze

  def expired?
    expires_at < DateTime.now.utc
  end

  def default_expires_at
    DateTime.now.utc + DEFAULT_EXPIRATION_TIMES[kind]
  end

  def default_code_generation
    SecureRandom.urlsafe_base64
  end

  def reset_or_create
    retries ||= 0

    begin
      self.expires_at = default_expires_at
      self.code = default_code_generation
      save!
    rescue ActiveRecord::RecordNotUnique
      retry_if (retries += 1) <= 3 # rubocop:disable Lint/UselessAssignment

      Rollbar.error("Code generation failed for #{user_id}")
    end
  end
end
