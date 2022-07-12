require 'rails_helper'

RSpec.describe "MerchantItems API", type: :request do
  let!(:merchant) { create(:merchant) }
  let!(:items) { create_list(:item, 5, merchant: merchant) }

  describe "happy path, fetch all items" do
    it 'gets all the items for a specific merchant' do
      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items.count).to eq(5)
      expect(items.first[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
    end
  end

  describe 'sad path, bad integer id returns 404' do
    it 'error when merchant does not exist' do
      get "/api/v1/merchants/8923987297/items"

      expect(response).to have_http_status(404)
    end
  end
end
