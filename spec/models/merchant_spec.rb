# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '#find_by_name(name_search)' do
      it 'returns records alphabetically that match the search params' do
        merch1 = create(:merchant, name: 'Turing')
        merch2 = create(:merchant, name: 'Ring World')
        expect(Merchant.find_by_name('ring')).to eq([merch2, merch1])
      end

      it 'returns an array with nil if the params are nil' do
        create(:merchant, name: 'Turing')
        create(:merchant, name: 'Ring World')
        expect(Merchant.find_by_name(nil)).to eq([nil])
      end
    end
  end
end
