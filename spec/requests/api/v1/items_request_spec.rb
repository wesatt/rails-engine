# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  let!(:items1) { create_list(:item, 5, merchant: merchant1) }
  let!(:items2) { create_list(:item, 5, merchant: merchant2) }

  describe 'Items#index' do
    describe 'happy path, fetch all items' do
      it 'index displays all items across all merchants' do
        get '/api/v1/items'

        expect(response).to be_successful

        items = json[:data]

        expect(items.count).to eq(10)
        expect(items.first[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
      end
    end
  end

  describe 'Items#show' do
    describe 'happy path, fetch one item by id' do
      it 'show page can show a single item by id' do
        get "/api/v1/items/#{items1[1].id}"

        expect(response).to be_successful

        item = json[:data]

        expect(item.count).to eq(3)
        expect(item).to include(:id, :type, :attributes)
        expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
      end
    end

    describe 'sad path, bad integer id returns 404' do
      it 'show page returns error when item does not exist' do
        get '/api/v1/items/8923987297'

        expect(response).to have_http_status(404)
      end
    end

    describe 'edge case, string id returns 404' do
      it 'show page retruns an error if id is a string' do
        get '/api/v1/items/one'

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Items#create and Items#destroy' do
    describe 'response should be okay to process' do
      it 'creates and deletes an item' do
        # creates an item
        new_item_params = {
          name: 'Whatsit',
          description: 'A nice thing',
          unit_price: 16.99,
          merchant_id: merchant1.id
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/items', headers: headers, params: JSON.generate(item: new_item_params)
        item = Item.last

        expect(response).to have_http_status(201)
        expect(item.name).to eq(new_item_params[:name])
        expect(item.description).to eq(new_item_params[:description])
        expect(item.unit_price).to eq(new_item_params[:unit_price])
        expect(item.merchant_id).to eq(new_item_params[:merchant_id])

        # deletes an item
        delete "/api/v1/items/#{item.id}"

        expect(response).to have_http_status(200)
        item2 = Item.last
        expect(item2.name).to_not eq(new_item_params[:name])
      end
    end
  end

  describe 'Items#update' do
    describe 'happy path, fetch one item by id' do
      it "updates an item's attributes" do
        item = create(:item, merchant: merchant1)
        new_params = {
          name: 'Whatsit',
          description: 'A nice thing',
          unit_price: 16.99,
          merchant_id: merchant2.id
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: new_params)
        new_properties = Item.find(item.id)

        expect(response).to have_http_status(202)
        expect(new_properties.name).to_not eq(item.name)
        expect(new_properties.name).to eq(new_params[:name])
        expect(new_properties.description).to_not eq(item.description)
        expect(new_properties.description).to eq(new_params[:description])
        expect(new_properties.unit_price).to_not eq(item.unit_price)
        expect(new_properties.unit_price).to eq(new_params[:unit_price])
        expect(new_properties.merchant_id).to_not eq(item.merchant_id)
        expect(new_properties.merchant_id).to eq(new_params[:merchant_id])
      end
    end

    describe 'happy path, works with only partial data, too' do
      it "updates an item's attributes with partial data" do
        item = create(:item, merchant: merchant1)
        new_params = {
          name: 'Whatsit'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: new_params)
        new_properties = Item.find(item.id)

        expect(response).to have_http_status(202)
        expect(new_properties.name).to_not eq(item.name)
        expect(new_properties.name).to eq(new_params[:name])
        expect(new_properties.description).to eq(item.description)
        expect(new_properties.unit_price).to eq(item.unit_price)
        expect(new_properties.merchant_id).to eq(item.merchant_id)
      end
    end

    describe 'sad path, bad integer id returns 404' do
      it 'returns error with invalid id' do
        new_params = {
          name: 'Whatsit'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch '/api/v1/items/8923987297', headers: headers, params: JSON.generate(item: new_params)

        expect(response).to have_http_status(404)
      end
    end

    describe 'edge case, string id returns 404' do
      it 'returns error id id is string' do
        new_params = {
          name: 'Whatsit'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch '/api/v1/items/one', headers: headers, params: JSON.generate(item: new_params)

        expect(response).to have_http_status(404)
      end
    end

    describe 'edge case, bad merchant id returns 400 or 404' do
      it 'returns error if merchant id is invalid' do
        new_params = {
          name: 'Whatsit',
          merchant_id: 8_923_987_297
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        patch '/api/v1/items/one', headers: headers, params: JSON.generate(item: new_params)

        expect(response).to have_http_status(404)
      end
    end
  end
end
