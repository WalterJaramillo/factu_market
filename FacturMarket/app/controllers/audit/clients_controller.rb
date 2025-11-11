# frozen_string_literal: true
require 'json'

module Audit
  class ClientsController < ApplicationController
    # We expect JSON payloads. Ensure protect_from_forgery is disabled for API path or use token auth.
    protect_from_forgery with: :null_session

    # POST /audit/clients
    def create
      payload = params.permit(:action, :client_id, :user_id, changed_data: {}).to_h

      unless %w[create update delete].include?(payload['action'])
        render json: { error: 'invalid action' }, status: :bad_request and return
      end

      changed_data = payload['changed_data'] || {}
      record_id = payload['client_id'].to_s
      user_id = payload['user_id']

      service = AuditService.new
      ok = service.log_action(
        action: payload['action'],
        model: 'Client',
        record_id: record_id,
        changed_data: changed_data,
        user_id: user_id
      )

      if ok
        render json: { status: 'ok' }, status: :created
      else
        render json: { status: 'error', message: 'failed to persist audit' }, status: :internal_server_error
      end
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end
end
