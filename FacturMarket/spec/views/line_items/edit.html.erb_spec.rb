require 'rails_helper'

RSpec.describe "line_items/edit", type: :view do
  let(:line_item) {
    LineItem.create!(
      invoice: nil,
      description: "MyString",
      quantity: 1,
      price: "9.99",
      subtotal: "9.99"
    )
  }

  before(:each) do
    assign(:line_item, line_item)
  end

  it "renders the edit line_item form" do
    render

    assert_select "form[action=?][method=?]", line_item_path(line_item), "post" do

      assert_select "input[name=?]", "line_item[invoice_id]"

      assert_select "input[name=?]", "line_item[description]"

      assert_select "input[name=?]", "line_item[quantity]"

      assert_select "input[name=?]", "line_item[price]"

      assert_select "input[name=?]", "line_item[subtotal]"
    end
  end
end
