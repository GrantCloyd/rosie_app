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
FactoryBot.define do
  factory :token do
    user
    code  { SecureRandom.hex(36) }

    trait :recovery do
      kind { :recovery }
      expires_at { DateTime.now.utc + Token::DEFAULT_EXPIRATION_TIMES[:recovery] }
    end

    trait :authentication do
      kind { :authentication }
      expires_at { DateTime.now.utc + Token::DEFAULT_EXPIRATION_TIMES[:authentication] }
    end
  end
end
