# frozen_string_literal: true

module Invites
  class MassAddService
    attr_reader :results

    def initialize(params:, group:, sender:)
      @params = params
      @target_emails = params[:target_emails].split
      @group = group
      @sender = sender
      @results = { success: [], errors: [] }
    end

    def call
      @target_emails.each do |email|
        invite = Invites::CreatorService.new(
          params: @params.except(:target_emails).merge({ target_email: email }),
          group: @group,
          sender: @sender
        ).call

        if invite.errors.present?
          @results[:errors] << invite
        else
          @results[:success] << invite
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
