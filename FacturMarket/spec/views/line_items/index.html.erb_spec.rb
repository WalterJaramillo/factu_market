require 'rails_helper'

RSpec.describe "line_items/index", type: :view do
  before(:each) do
    assign(:line_items, [
      LineItem.create!(
        invoice: nil,
        description: "Description",
        quantity: 2,
        price: "9.99",
        subtotal: "9.99"
      ),
      LineItem.create!(
        invoice: nil,
        description: "Description",
        quantity: 2,
        price: "9.99",
        subtotal: "9.99"
      )
    ])
  end

  it "renders a list of line_items" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
  end
end
