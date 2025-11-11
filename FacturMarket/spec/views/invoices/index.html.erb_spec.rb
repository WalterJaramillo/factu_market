require 'rails_helper'

RSpec.describe "invoices/index", type: :view do
  before(:each) do
    assign(:invoices, [
      Invoice.create!(
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
      ),
      Invoice.create!(
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
      )
    ])
  end

  it "renders a list of invoices" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Series".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Issuer Nit".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Issuer Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Receiver Nit".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Receiver Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end
