# frozen_string_literal: true

module Invites
  class MassAddService
    attr_reader :results

    def initialize(params:, topic:)
      @params = params
      @target_emails = params[:target_emails].split(' ')
      @topic = topic
      @results = { success: [], errors: [] }
    end

    def call
      @target_emails.each do |email|
        invite = Invites::CreatorService.new(
          params: @params.except(:target_emails).merge({ target_email: email }),
          topic: @topic
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
        error_array << "** Invite for #{invalid_invite.target_email} could not be sent: #{invalid_invite.errors.full_messages.to_sentence}"
      end.join("\n\n")
    end
  end
end
