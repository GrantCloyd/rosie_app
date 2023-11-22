module Users
  class CreatorService

    def initialize(user_params:)
      @user_params = user_params
    end

    def call
      @user = User.new(@user_params)
      
      ActiveRecord::Base.transaction do 
        if @user.valid?
         create_preferences!
         @user.save!
        end
      end

      @user
    end

    private

    def create_preferences!
      @user.build_user_preference
      @user.user_preference.save!
    end
  end
end