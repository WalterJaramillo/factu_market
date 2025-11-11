class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.string :series
      t.integer :number
      t.string :issuer_nit
      t.string :issuer_name
      t.string :receiver_nit
      t.string :receiver_name
      t.date :issue_date
      t.decimal :subtotal, precision: 15, scale: 2
      t.decimal :total, precision: 15, scale: 2
      t.decimal :vat, precision: 15, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
