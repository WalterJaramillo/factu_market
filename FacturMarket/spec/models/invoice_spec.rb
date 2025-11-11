# spec/models/invoice_spec.rb
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it "genera numero secuencial por serie" do
    i1 = Invoice.create!(
      serie: 'FE',
      nit_emisor: '800000000',
      nombre_emisor: 'A',
      nit_receptor: '900000000',
      nombre_receptor: 'B',
      fecha_emision: Date.today,
      total: 100,
      subtotal: 84.03,
      iva: 15.97
    )

    i2 = Invoice.create!(
      serie: 'FE',
      nit_emisor: '800000000',
      nombre_emisor: 'A',
      nit_receptor: '900000000',
      nombre_receptor: 'B',
      fecha_emision: Date.today,
      total: 200,
      subtotal: 168.07,
      iva: 31.93
    )

    expect(i2.numero).to eq(i1.numero + 1)
  end
end
