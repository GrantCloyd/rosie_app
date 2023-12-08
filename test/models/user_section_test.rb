# frozen_string_literal: true

# == Schema Information
#
# Table name: user_sections
#
#  id               :bigint           not null, primary key
#  permission_level :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  section_id       :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_user_sections_on_section_id              (section_id)
#  index_user_sections_on_user_id                 (user_id)
#  index_user_sections_on_user_id_and_section_id  (user_id,section_id) UNIQUE
#
require 'test_helper'

class UserSectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end