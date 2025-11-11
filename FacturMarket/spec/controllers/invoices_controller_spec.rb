require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  describe "DELETE #destroy" do
    let!(:invoice) { create(:invoice) }

    it "elimina la factura y redirige con mensaje" do
      expect {
        delete :destroy, params: { id: invoice.id }
      }.to change(Invoice, :count).by(-1)

      expect(response).to redirect_to(invoices_path)
      expect(flash[:notice]).to eq("Factura eliminada correctamente")
    end
  end
end