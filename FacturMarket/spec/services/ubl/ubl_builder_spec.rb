# spec/services/ubl/ubl_builder_spec.rb
require 'rails_helper'

RSpec.describe Ubl::UblBuilder do
  it "genera xml con nodos básicos" do
    invoice = create(:invoice) # define factories con factory_bot
    invoice.line_items.create!(descripcion: 'Item 1', cantidad: 1, precio: 100, subtotal: 100)
    
    xml = Ubl::UblBuilder.new(invoice).build
    
    expect(xml).to include("<cbc:ID")
    expect(xml).to include(invoice.nit_emisor)
    expect(xml).to include(invoice.nit_receptor)
  end
end
