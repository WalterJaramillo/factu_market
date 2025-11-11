require 'rails_helper'

RSpec.describe "Landings", type: :request do
  describe "GET /welcome" do
    it "returns http success" do
      get "/landing/welcome"
      expect(response).to have_http_status(:success)
    end
  end

end
