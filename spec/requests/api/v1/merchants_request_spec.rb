require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  let!(:merchants) { create_list(:merchant, 5) }
  let!(:items) { create_list(:item, 5, merchant: merchants[0]) }
  describe "GET /index" do
    it "returns a json of all the books" do
      get '/api/v1/merchants'

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]

      merchants.each do |merchant|
        expect(merchant).to be_a(Hash)
        expect(merchant).to include(:id)
      end
    end
  end
end
