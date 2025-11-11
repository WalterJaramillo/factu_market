require 'rails_helper'

RSpec.describe "line_items/show", type: :view do
  before(:each) do
    assign(:line_item, LineItem.create!(
      invoice: nil,
      description: "Description",
      quantity: 2,
      price: "9.99",
      subtotal: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
