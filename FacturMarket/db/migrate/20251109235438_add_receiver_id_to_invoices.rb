class AddReceiverIdToInvoices < ActiveRecord::Migration[7.2]
  def change
    add_column :invoices, :receiver_id, :integer
  end
end
