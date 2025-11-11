require 'rails_helper'

RSpec.describe "line_items/new", type: :view do
  before(:each) do
    assign(:line_item, LineItem.new(
      invoice: nil,
      description: "MyString",
      quantity: 1,
      price: "9.99",
      subtotal: "9.99"
    ))
  end

  it "renders new line_item form" do
    render

    assert_select "form[action=?][method=?]", line_items_path, "post" do

      assert_select "input[name=?]", "line_item[invoice_id]"

      assert_select "input[name=?]", "line_item[description]"

      assert_select "input[name=?]", "line_item[quantity]"

      assert_select "input[name=?]", "line_item[price]"

      assert_select "input[name=?]", "line_item[subtotal]"
    end
  end
end
