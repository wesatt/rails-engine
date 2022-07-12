require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  let!(:merchants) { create_list(:merchant, 5) }

  describe "happy path, all merchants returned are same as in db" do
    it "returns a json of all the merchants" do
      get '/api/v1/merchants'

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]

      merchants.each do |merchant|
        expect(merchant).to be_a(Hash)
        expect(merchant).to include(:id)
      end
    end
  end

  describe "happy path, fetch one merchant by id" do
    it "returns a json of the specified merchant" do
      get "/api/v1/merchants/#{merchants.first.id}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to include(:name)
    end
  end

  describe "sad path, bad integer id returns 404" do
    it "returns a 404 error when the merchant cannot be found" do
      get '/api/v1/merchants/8923987297'

      expect(response).to have_http_status(404)
    end
  end
end
