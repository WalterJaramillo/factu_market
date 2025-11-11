# spec/jobs/generate_invoice_files_job_spec.rb
require 'rails_helper'

RSpec.describe GenerateInvoiceFilesJob, type: :job do
  include ActiveJob::TestHelper

  it "enqueue and perform" do
    invoice = create(:invoice)

    expect {
      GenerateInvoiceFilesJob.perform_now(invoice.id)
    }.not_to raise_error

    invoice.reload
    expect(invoice.xml_file).to be_attached
    expect(invoice.pdf_file).to be_attached
  end
end
