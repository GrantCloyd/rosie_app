# frozen_string_literal: true

module Invites
  class MassAddService
    attr_reader :errors, :successes

    def initialize(params:, group:, sender_name:)
      @target_emails = params[:target_emails].split
      @params = params.except(:target_emails)
      @group = group
      @sender_name = sender_name
      @successes = []
      @errors = []
    end

    def create_invites
      @target_emails.each do |email|
        invite = Invites::CreatorService.new(
          params: @params.merge({ target_email: email }),
          group: @group,
          sender_name: @sender_name
        ).call

        if invite.errors.present?
          @errors << invite
        else
          @successes << invite
        end
      end
    end

    def display_error_messages
      @errors.each_with_object([]) do |invalid_invite, error_array|
        error_array << "** Invite for #{invalid_invite.target_email} could not be sent: #{format_errors(invalid_invite)}"
      end.join("\n\n")
    end

    private

    # keep in sync with ApplicationController verion of method
    def format_errors(object)
      object.errors.full_messages.to_sentence.to_s
    end
  end
end
