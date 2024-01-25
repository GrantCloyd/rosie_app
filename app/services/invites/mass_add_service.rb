# frozen_string_literal: true

module Invites
  class MassAddService
    attr_reader :results

    def initialize(params:, group:, sender_name:)
      @target_emails = params[:target_emails].split
      @params = params.except(:target_emails)
      @group = group
      @sender_name = sender_name
      @results = { successes: [], errors: [] }
    end

    def create_invites
      @target_emails.each do |email|
        invite = Invites::CreatorService.new(
          params: @params.merge({ target_email: email }),
          group: @group,
          sender_name: @sender_name
        ).call

        if invite.errors.present?
          @results[:errors] << invite
        else
          @results[:successes] << invite
        end
      end
    end

    def display_error_messages
      @results[:errors].each_with_object([]) do |invalid_invite, error_array|
        error_array << "** Invite for #{invalid_invite.target_email} could not be sent: #{format_errors(invalid_invite)}"
      end.join("\n\n")
    end
  end
end
