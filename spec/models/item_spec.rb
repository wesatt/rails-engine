# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'class methods' do
    describe '#find_all(name_search)' do
      let!(:merchant1) { create(:merchant) }
      let!(:merchant2) { create(:merchant) }

      it 'returns an array of all items that match criteria' do
        # must be either name, min, max, or min and max, but never name and min and/or max
        item1 = create(:item, name: 'Wild Rice', unit_price: 9.50, merchant_id: merchant1.id)
        item2 = create(:item, name: 'White Rice', unit_price: 10.50, merchant_id: merchant2.id)
        item3 = create(:item, name: 'Brown Rice', unit_price: 5.50, merchant_id: merchant2.id)
        item4 = create(:item, name: 'Kodama Charm', unit_price: 16.50, merchant_id: merchant1.id)
        item5 = create(:item, name: 'Price Checker', unit_price: 10.00, merchant_id: merchant1.id)
        name_only = {name: 'rice'}
        min_only = {min_price: 10}
        max_only = {max_price: 10}
        min_and_max = {min_price: 9, max_price: 20}

        expect(Item.find_all(name_only)).to eq([item3, item5, item2, item1])
        expect(Item.find_all(min_only)).to eq([item2, item4, item5])
        expect(Item.find_all(max_only)).to eq([item1, item3, item5])
        expect(Item.find_all(min_and_max)).to eq([item1, item2, item4, item5])
      end
    end
  end
end
