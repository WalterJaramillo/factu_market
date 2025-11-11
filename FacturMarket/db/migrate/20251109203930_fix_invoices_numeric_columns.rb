class FixInvoicesNumericColumns < ActiveRecord::Migration[7.0]
  def up
    # Cambiar el tipo de columna 'number' para asegurar que sea INTEGER
    change_column :invoices, :number, :integer, null: false
    
    # Asegurar que las columnas decimales tengan la precisión correcta
    change_column :invoices, :subtotal, :decimal, precision: 15, scale: 2, null: false
    change_column :invoices, :total, :decimal, precision: 15, scale: 2, null: false
    change_column :invoices, :vat, :decimal, precision: 5, scale: 2, null: false
    
    # Agregar valores por defecto si es necesario
    change_column_default :invoices, :status, from: nil, to: 'draft'
    
    # Agregar índice único para evitar duplicados
    add_index :invoices, [:series, :number], unique: true, name: 'idx_unique_invoice_series_number' unless index_exists?(:invoices, [:series, :number])
  end

  def down
    remove_index :invoices, name: 'idx_unique_invoice_series_number' if index_exists?(:invoices, name: 'idx_unique_invoice_series_number')
    change_column_default :invoices, :status, from: 'draft', to: nil
    
    change_column :invoices, :number, :integer, precision: 38
    change_column :invoices, :subtotal, :decimal, precision: 15, scale: 2
    change_column :invoices, :total, :decimal, precision: 15, scale: 2
    change_column :invoices, :vat, :decimal, precision: 15, scale: 2
  end
end