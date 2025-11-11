# frozen_string_literal: true
require 'mongoid'

# Collection: audit_logs
class AuditLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created # created_at

  store_in collection: 'audit_logs'

  field :action,       type: String   # create, update, delete
  field :model,        type: String   # Client, Invoice
  field :record_id,    type: String
  field :changed_data, type: Hash, default: {}
  field :user_id,      type: String
  field :timestamp,    type: Time, default: ->{ Time.now.utc }

  validates :action, presence: true, inclusion: { in: %w[create update delete edit] }
  validates :model, presence: true
  validates :record_id, presence: true

  # optional: index for performance
  index({ model: 1, record_id: 1, timestamp: -1 })
end

