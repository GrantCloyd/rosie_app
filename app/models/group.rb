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
end
