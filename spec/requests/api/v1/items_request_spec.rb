require 'rails_helper'

RSpec.describe "Items", type: :request do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  let!(:items1) { create_list(:item, 5, merchant: merchant1) }
  let!(:items2) { create_list(:item, 5, merchant: merchant2) }

  describe "happy path, fetch all items" do
    it 'displays all items across all merchants' do
      get '/api/v1/items'

      expect(response).to be_successful

      items = json[:data]

      expect(items.count).to eq(10)
    end
  end
end
