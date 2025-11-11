# app/jobs/generate_invoice_files_job.rb
class GenerateInvoiceFilesJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)

    # 1) Generate PDF
    pdf_binary = Pdf::Generator.new(invoice).call
    invoice.pdf_file.attach(
      io: StringIO.new(pdf_binary),
      filename: "#{invoice.series}-#{invoice.number}.pdf",
      content_type: 'application/pdf'
    )

    # 2) Generate XML UBL
    xml_str = Ubl::UblBuilder.new(invoice).build

    # Optional: Sign XML here using nokogiri-xmlsec (external)
    # signed_xml = XmlSigner.sign(xml_str, certificate: ENV['CERT_P12'], password: ENV['CERT_PASS'])

    invoice.xml_file.attach(
      io: StringIO.new(xml_str),
      filename: "#{invoice.series}-#{invoice.number}.xml",
      content_type: 'application/xml'
    )

    invoice.save!
  rescue => e
    Rails.logger.error("Error generating files for invoice #{invoice_id}: #{e.message}\n#{e.backtrace.join("\n")}")
    raise e
  end
end
