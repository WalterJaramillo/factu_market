require 'rails_helper'

RSpec.describe "invoices/show", type: :view do
  before(:each) do
    assign(:invoice, Invoice.create!(
      series: "Series",
      number: 2,
      issuer_nit: "Issuer Nit",
      issuer_name: "Issuer Name",
      receiver_nit: "Receiver Nit",
      receiver_name: "Receiver Name",
      subtotal: "9.99",
      total: "9.99",
      vat: "9.99",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Series/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Issuer Nit/)
    expect(rendered).to match(/Issuer Name/)
    expect(rendered).to match(/Receiver Nit/)
    expect(rendered).to match(/Receiver Name/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Status/)
  end
end
