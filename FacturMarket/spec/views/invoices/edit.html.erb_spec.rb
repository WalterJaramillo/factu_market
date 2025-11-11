require 'rails_helper'

RSpec.describe "invoices/edit", type: :view do
  let(:invoice) {
    Invoice.create!(
      series: "MyString",
      number: 1,
      issuer_nit: "MyString",
      issuer_name: "MyString",
      receiver_nit: "MyString",
      receiver_name: "MyString",
      subtotal: "9.99",
      total: "9.99",
      vat: "9.99",
      status: "MyString"
    )
  }

  before(:each) do
    assign(:invoice, invoice)
  end

  it "renders the edit invoice form" do
    render

    assert_select "form[action=?][method=?]", invoice_path(invoice), "post" do

      assert_select "input[name=?]", "invoice[series]"

      assert_select "input[name=?]", "invoice[number]"

      assert_select "input[name=?]", "invoice[issuer_nit]"

      assert_select "input[name=?]", "invoice[issuer_name]"

      assert_select "input[name=?]", "invoice[receiver_nit]"

      assert_select "input[name=?]", "invoice[receiver_name]"

      assert_select "input[name=?]", "invoice[subtotal]"

      assert_select "input[name=?]", "invoice[total]"

      assert_select "input[name=?]", "invoice[vat]"

      assert_select "input[name=?]", "invoice[status]"
    end
  end
end
