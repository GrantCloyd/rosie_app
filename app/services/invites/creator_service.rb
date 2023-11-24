module Invites
  class CreatorService

    def initialize(params:, topic:)
      @params = params
      @topic = topic
      find_user_if_present
    end

    def call
      invite = build_invite
      
      if invite.valid?
        invite.save!
      end
      
      invite
    end

    private 

    def find_user_if_present
      return @user if defined?(@user)
      @user ||= User.find_by(email: @params[:target_email])
    end

    def build_invite
      if @user.present?
        @topic.invites.new(@params.merge({user_id: @user.id}))
      else
        @topic.invites.new(@params)
      end
    end
  end
end