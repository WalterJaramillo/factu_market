class ChangeNitColumnsToString < ActiveRecord::Migration[7.2]
  def change
    def change
      change_column :invoices, :issuer_nit, :string
      change_column :invoices, :receiver_nit, :string
    end
  end
end
