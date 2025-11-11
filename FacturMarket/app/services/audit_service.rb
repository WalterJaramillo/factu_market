# frozen_string_literal: true
require 'logger'

class AuditService
  # audit_model must respond to .create! (default: AuditLog)
  def initialize(audit_model: AuditLog, logger: Rails.respond_to?(:logger) ? Rails.logger : Logger.new($stdout))
    @audit_model = audit_model
    @logger = logger
  end

  # Public API
  # action: 'create'|'update'|'delete'
  # model: 'Client'|'Invoice'
  # record_id: string (id of the record)
  # changed_data: hash with before/after data
  # user_id: string or nil
  def log_action(action:, model:, record_id:, changed_data:, user_id: nil)
    payload = {
      action: action.to_s,
      model: model.to_s,
      record_id: record_id.to_s,
      changed_data: (changed_data || {}),
      user_id: user_id,
      timestamp: Time.now.utc
    }

    validate_payload!(payload)

    begin
      @audit_model.create!(payload)
    rescue => e
      # Manejar errores de conexión o validación sin interrumpir la app primaria.
      # Loguear y re-lanzar si se desea; por defecto sólo logueamos y retornamos false.
      @logger.error("[AuditService] Failed to persist audit log: #{e.class} #{e.message} -- payload: #{payload.inspect}")
      return false
    end

    true
  end

  private

  def validate_payload!(payload)
    unless %w[create update delete].include?(payload[:action])
      raise ArgumentError, "Invalid action: #{payload[:action]}"
    end

    raise ArgumentError, "model is required" if payload[:model].to_s.strip.empty?
    raise ArgumentError, "record_id is required" if payload[:record_id].to_s.strip.empty?
    # changed_data may be empty hash, that's válido
  end
end
