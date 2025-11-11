# app/models/line_item.rb
class LineItem < ApplicationRecord
  # Relación: cada detalle pertenece a una factura (Invoice)
  belongs_to :invoice

  # Antes de validar, calcular el subtotal automáticamente
  before_validation :calculate_subtotal

  # Validaciones de presencia y valores numéricos
  validates :description, :quantity, :price, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Calcula el subtotal de cada línea (cantidad × precio)
  def calculate_subtotal
    self.subtotal = (quantity.to_i * price.to_d).round(2)
  end
end
