# app/jobs/send_invoice_email_job.rb
class SendInvoiceEmailJob < ApplicationJob
  queue_as :mailers

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    InvoiceMailer.with(invoice: invoice).send_invoice.deliver_now
  rescue => e
    Rails.logger.error("Error sending invoice email #{invoice_id}: #{e.message}")
    raise e
  end
end
