class ChangeInvoiceAmountsToDecimal < ActiveRecord::Migration[7.2]
  def change
    def change
      change_column :invoices, :subtotal, :decimal, precision: 15, scale: 2
      change_column :invoices, :total, :decimal, precision: 15, scale: 2
      change_column :invoices, :vat, :decimal, precision: 15, scale: 2
    end
  end
end
