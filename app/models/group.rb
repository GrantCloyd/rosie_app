# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  status     :integer          default(0), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Group < ActiveRecord::Base
    has_many :user_groups

    enum status: {
        closed: 0,
        open: 1,
        deactivated: 2
      }

      scope :in_order, lambda {
        order(created_at: :DESC)
      }
end
