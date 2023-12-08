module Sections
  class CreatorService
    def initialize(params:, user:)
      @section = Section.new(params)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        if @section.valid?
          create_user_section!
          @section.save!
        end

        @section
      end
    end

    def create_user_section!
      user_section = UserSection.new(
        user: @user,
        section: @section,
        permission_level: :creator
      )
      user_section.save!
    end
  end
end