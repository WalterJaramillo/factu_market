require 'active_support/all'
class Invoice < ApplicationRecord
  # Convertir a Float antes de guardar (para Oracle)

  before_save :convert_decimals_for_oracle

  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true


  has_one_attached :pdf_file
  has_one_attached :json_file

  before_validation :calculate_totals_if_needed, on: [:create, :update]
  before_validation :ensure_sequential_number, on: :create

  validates :series, :number, :issuer_nit, :issuer_name, :receiver_id,
            :receiver_nit,:issue_date,
            :total, presence: true

  attribute :subtotal, :float
  attribute :total, :float
  attribute :vat, :float

   validates :subtotal, :total, :vat, numericality: true

  validates :number, numericality: { only_integer: true, greater_than: 0 }
  validates :issuer_nit, :receiver_nit, format: { with: /\A\d+\z/, message: "debe contener solo dígitos" }
  validates :subtotal, :total, :vat, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :number, uniqueness: { scope: :series }

  enum status: { draft: 'draft', issued: 'issued', canceled: 'canceled' }

  def issue!(user: nil)
    transaction do
      self.status = 'issued'
      save!
      GenerateInvoiceFilesJob.perform_later(self.id) if defined?(GenerateInvoiceFilesJob)
      SendInvoiceEmailJob.perform_later(self.id) if defined?(SendInvoiceEmailJob)
    end
  end

  #after_create_commit :send_invoice_email
  #Envio del email con mailer
  after_create :send_invoice_email

  # Inyección: permite reemplazar en tests si se quiere
  cattr_accessor :audit_service_class
  self.audit_service_class = AuditService

  # Callbacks to create audit logs.
  after_create  :audit_create
  after_update  :audit_update
  after_destroy :audit_delete


  private

  def send_invoice_email
    InvoiceMailer.with(invoice: self).invoice_email.deliver_later
  end

  #def send_invoice_email
   # InvoiceMailer.with(invoice: self).send_invoice.deliver_now
  #end



  # Convertir BigDecimal a Float para Oracle Enhanced Adapter
  def convert_decimals_for_oracle
    # Convertir number a integer
    self.number = number.to_i if number.present?
    
    # Convertir decimales a float
    self.subtotal = subtotal.to_f if subtotal.present?
    self.total = total.to_f if total.present?
    self.vat = vat.to_f if vat.present?
    
    Rails.logger.debug "Oracle conversion - Number: #{number} (#{number.class}), Subtotal: #{subtotal} (#{subtotal.class})"
  end

  def calculate_totals_if_needed
    return unless line_items.any?

    calculated_subtotal = line_items.sum { |li| (li.quantity.to_f * li.price.to_f) }
    
    self.subtotal = calculated_subtotal.round(2)
    self.vat = (subtotal * 0.19).round(2)
    self.total = (subtotal + vat).round(2)
  end

  def ensure_sequential_number
    return if number.present? && number.to_i > 0

    Invoice.transaction(requires_new: true) do
      last_num = Invoice.where(series: series).lock.maximum(:number) || 0
      self.number = last_num + 1
    end
  end
   def audit_create
    service = self.class.audit_service_class.new
    changed_data = { before: nil, after: attributes_for_audit }
    service.log_action(
      action: 'create',
      model: 'Invoice',
      record_id: id.to_s,
      changed_data: changed_data,
      user_id: current_user_id_from_thread
    )
  end

  def audit_update
    service = self.class.audit_service_class.new
    # saved_changes -> { "field" => [before, after], ... }
    relevant = saved_changes.except('updated_at') # omitimos updated_at salvo que quieras incluirlo
    changed_data = relevant.transform_values do |pair|
      { before: pair[0], after: pair[1] }
    end
    service.log_action(
      action: 'update',
      model: 'Invoice',
      record_id: id.to_s,
      changed_data: changed_data,
      user_id: current_user_id_from_thread
    )
  end

  def audit_delete
    service = self.class.audit_service_class.new
    changed_data = { before: attributes_for_audit, after: nil }
    service.log_action(
      action: 'delete',
      model: 'Invoice',
      record_id: id.to_s,
      changed_data: changed_data,
      user_id: current_user_id_from_thread
    )
  end

  def attributes_for_audit
    # escoge qué atributos incluir. Por defecto incluimos atributos serializables.
    # Evitar incluir datos sensibles o blobs.
    attributes.except('created_at', 'updated_at')
  end

  # Mecanismo común para obtener user_id que ejecuta la acción.
  # No mezclamos lógica de obtención de usuario con AuditService — lo único que hacemos
  # es leer una convención: Thread.current[:current_user_id] (o nil).
  def current_user_id_from_thread
    Thread.current[:current_user_id]
  end

end