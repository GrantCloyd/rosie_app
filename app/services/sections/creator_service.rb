# frozen_string_literal: true

module Sections
  class CreatorService
    def initialize(params:, user:, user_group:)
      @section = Section.new(params)
      @user = user
      @user_group = user_group
    end

    def call
      ActiveRecord::Base.transaction do
        if @section.valid?
          create_user_group_section!
          @section.save!
        end

        @section
      end
    end

    def create_user_group_section!
      user_group_section = UserGroupSection.new(
        section: @section,
        user_group: @user_group,
        permission_level: :creator
      )
      user_group_section.save!
    end
  end
end
