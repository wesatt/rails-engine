# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  describe 'Section 1' do
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

          expect(response).to be_successful
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

          expect(response).to be_successful
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

  describe 'Section Two' do
    let!(:merchant1) { create(:merchant) }
    let!(:merchant2) { create(:merchant) }

    describe 'Items#find_all' do
      describe 'happy path, fetch all items matching a pattern' do
        it 'returns all items that match the given criteria' do
          item1 = create(:item, name: 'Wild Rice', unit_price: 9.50, merchant_id: merchant1.id)
          item2 = create(:item, name: 'White Rice', unit_price: 10.50, merchant_id: merchant2.id)
          item3 = create(:item, name: 'Brown Rice', unit_price: 5.50, merchant_id: merchant2.id)
          item4 = create(:item, name: 'Kodama Charm', unit_price: 16.50, merchant_id: merchant1.id)
          item5 = create(:item, name: 'Price Checker', unit_price: 10.00, merchant_id: merchant1.id)

          get '/api/v1/items/find_all?name=rice'
          expect(response).to be_successful
          results = json[:data]
          first_item = results[0][:attributes]
          expect(results).to be_a(Array)
          expect(results.count).to eq(4)
          expect(first_item[:name]).to eq(item3.name)
          expect(first_item[:description]).to eq(item3.description)
          expect(first_item[:unit_price]).to eq(item3.unit_price)
          expect(first_item[:merchant_id]).to eq(item3.merchant_id)
          expect(results[1][:attributes][:name]).to eq(item5.name)
          expect(results[2][:attributes][:name]).to eq(item2.name)
          expect(results[3][:attributes][:name]).to eq(item1.name)

          get '/api/v1/items/find_all?min_price=10'
          expect(response).to be_successful
          results = json[:data]
          first_item = results[0][:attributes]
          expect(results).to be_a(Array)
          expect(results.count).to eq(3)
          expect(first_item[:name]).to eq(item2.name)
          expect(results[1][:attributes][:name]).to eq(item4.name)
          expect(results[2][:attributes][:name]).to eq(item5.name)

          get '/api/v1/items/find_all?max_price=10'
          expect(response).to be_successful
          results = json[:data]
          first_item = results[0][:attributes]
          expect(results).to be_a(Array)
          expect(results.count).to eq(3)
          expect(first_item[:name]).to eq(item1.name)
          expect(results[1][:attributes][:name]).to eq(item3.name)
          expect(results[2][:attributes][:name]).to eq(item5.name)

          get '/api/v1/items/find_all?max_price=20&min_price=9'
          expect(response).to be_successful
          results = json[:data]
          first_item = results[0][:attributes]
          expect(results).to be_a(Array)
          expect(results.count).to eq(4)
          expect(first_item[:name]).to eq(item1.name)
          expect(results[1][:attributes][:name]).to eq(item2.name)
          expect(results[2][:attributes][:name]).to eq(item4.name)
          expect(results[3][:attributes][:name]).to eq(item5.name)
        end
      end

      describe 'sad path, no fragment matched' do
        it 'returns an empty array when there is invalid, missing, or unmatched data' do
          create(:item, name: 'Wild Rice', unit_price: 9.50, merchant_id: merchant1.id)
          create(:item, name: 'White Rice', unit_price: 10.50, merchant_id: merchant2.id)
          create(:item, name: 'Brown Rice', unit_price: 5.50, merchant_id: merchant2.id)
          create(:item, name: 'Kodama Charm', unit_price: 16.50, merchant_id: merchant1.id)
          create(:item, name: 'Price Checker', unit_price: 10.00, merchant_id: merchant1.id)

          get '/api/v1/items/find_all?name=xxyzx'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all?min_price=99'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all?max_price=1'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all?max_price=30&min_price=20'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all?name='
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all?name=rice&min_price=10'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all?name=rice&max_price=10'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty

          get '/api/v1/items/find_all?name=rice&min_price=10&max_price=20'
          expect(response).to be_successful
          results = json
          expect(results[:data]).to be_a(Array)
          expect(results[:data].empty?).to eq(true)
          expect(results[:data]).to be_empty
        end
      end
    end
  end
end
