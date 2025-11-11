# frozen_string_literal: true
require 'rails_helper'
require 'mongoid'

RSpec.describe AuditService, type: :service do
  before(:all) do
    # Configurar Mongoid para los tests si no está configurado.
    # Usa ENV['MONGODB_URI'] si está presente, de lo contrario usa DB local de pruebas.
    mongo_uri = ENV.fetch('MONGODB_URI', 'mongodb://localhost:27017/rails_audit_db_test')
    Mongoid.configure do |config|
      config.clients.default = {
        uri: mongo_uri
      }
    end
  end

  before(:each) do
    # Limpiar colección antes de cada test
    AuditLog.delete_all
  end

  let(:service) { AuditService.new }

  it 'creates a create audit log' do
    ok = service.log_action(
      action: 'create',
      model: 'Invoice',
      record_id: 'inv-1',
      changed_data: { before: nil, after: { total: 100.0 } },
      user_id: 'user-1'
    )

    expect(ok).to be_truthy
    expect(AuditLog.count).to eq(1)
    log = AuditLog.first
    expect(log.action).to eq('create')
    expect(log.model).to eq('Invoice')
    expect(log.record_id).to eq('inv-1')
    expect(log.user_id).to eq('user-1')
    expect(log.changed_data['after']['total']).to eq(100.0)
  end

  it 'creates an update audit log' do
    ok = service.log_action(
      action: 'update',
      model: 'Invoice',
      record_id: 'inv-2',
      changed_data: { amount: { before: 10, after: 20 } },
      user_id: nil
    )
    expect(ok).to be_truthy
    expect(AuditLog.count).to eq(1)
    log = AuditLog.first
    expect(log.action).to eq('update')
    expect(log.model).to eq('Invoice')
    expect(log.record_id).to eq('inv-2')
    expect(log.user_id).to be_nil
    expect(log.changed_data['amount']['before']).to eq(10)
  end

  it 'creates a delete audit log' do
    ok = service.log_action(
      action: 'delete',
      model: 'Invoice',
      record_id: 'inv-3',
      changed_data: { before: { id: 'inv-3', total: 42 }, after: nil },
      user_id: 'admin'
    )
    expect(ok).to be_truthy
    expect(AuditLog.count).to eq(1)
    log = AuditLog.first
    expect(log.action).to eq('delete')
    expect(log.model).to eq('Invoice')
    expect(log.changed_data['before']['total']).to eq(42)
  end
end
