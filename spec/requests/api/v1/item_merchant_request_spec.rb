# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ItemMerchant API', type: :request do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  let!(:items1) { create_list(:item, 5, merchant: merchant1) }
  let!(:items2) { create_list(:item, 5, merchant: merchant2) }

  describe 'ItemMerchant#index' do
    describe 'happy path, fetch one merchant by id' do
      it 'shows the merchant for the item' do
        get "/api/v1/items/#{items1[1].id}/merchant"

        expect(response).to be_successful
        expect(json[:data]).to include(:id, :type, :attributes)
        expect(json[:data][:attributes][:name]).to eq(merchant1.name)
        expect(json[:data][:id].to_i).to eq(merchant1.id)
      end
    end

    describe 'sad path, bad integer id returns 404' do
      it 'returns an error if id is invlaid' do
        get '/api/v1/items/8923987297/merchant'

        expect(response).to have_http_status(404)
      end
    end

    describe 'edge case, string id returns 404' do
      it 'returns an error if id is string' do
        get '/api/v1/items/one/merchant'

        expect(response).to have_http_status(404)
      end
    end
  end
end
