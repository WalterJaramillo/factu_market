FactoryBot.define do
  factory :invoice do
    series        { "A001" }
    number        { 12345 }
    issuer_nit    { "900123456" }
    issuer_name   { "Empresa Emisora" }
    receiver_nit  { "800987654" }
    receiver_name { "Cliente Demo" }
    issue_date    { Date.today }
    subtotal      { 100 }
    vat           { 19 }
    total         { 119 }
    status        { "draft" }
    receiver_id   { 21 }

    trait :with_pdf do
      after(:build) do |invoice|
        invoice.pdf_file.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/sample.pdf')),
          filename: 'sample.pdf',
          content_type: 'application/pdf'
        )
      end
    end
  end
end