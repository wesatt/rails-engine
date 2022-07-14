# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchants API', type: :request do
  let!(:merchants) { create_list(:merchant, 5) }

  describe 'happy path, all merchants returned are same as in db' do
    it 'returns a json of all the merchants' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]

      expect(merchants).to be_a(Array)
      merchants.each do |merchant|
        expect(merchant).to be_a(Hash)
        expect(merchant).to include(:id)
      end
    end
  end

  describe 'happy path, fetch one merchant by id' do
    it 'returns a json of the specified merchant' do
      get "/api/v1/merchants/#{merchants.first.id}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to include(:name)
    end
  end

  describe 'sad path, bad integer id returns 404' do
    it 'returns a 404 error when the merchant cannot be found' do
      get '/api/v1/merchants/8923987297'

      expect(response).to have_http_status(404)
    end
  end

  describe 'Merchants#find' do
    describe 'happy path, fetch one merchant by fragment' do
      it 'will return the first result alphabetically that matches the search parameters' do
        create(:merchant, name: 'Turing')
        merchant_found = create(:merchant, name: 'Ring World')
        get '/api/v1/merchants/find?name=ring'

        expect(response).to be_successful
        expect(json).to be_a(Hash)
        expect(json.keys.count).to eq(3)
        expect(json).to include(:id, :type, :attributes)
        expect(json[:attributes]).to be_a(Hash)
        expect(json[:attributes][:name]).to eq(merchant_found.name)
      end
    end

    describe 'sad path, no fragment matched' do
      it 'will return' do
        get '/api/v1/merchants/find?name=zzyzx'

        expect(response).to be_successful
        expect(json).to be_a(Hash)
        expect(json.keys.count).to eq(3)
        expect(json).to include(:id, :type, :attributes)
        expect(json[:attributes]).to be_a(Hash)
        expect(json[:attributes][:name]).to eq(merchant_found.name)
      end
    end
  end
end
