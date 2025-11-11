require 'rails_helper'

RSpec.describe "invoices/new", type: :view do
  before(:each) do
    assign(:invoice, Invoice.new(
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
    ))
  end

  it "renders new invoice form" do
    render

    assert_select "form[action=?][method=?]", invoices_path, "post" do

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
