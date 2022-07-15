# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many(:items)
  has_many(:invoice_items, through: :items)
  has_many(:invoices, through: :invoice_items)
  has_many(:customers, through: :invoices)
  has_many(:transactions, through: :invoices)

  validates_presence_of :name

  def self.find_by_name(name_input)
    if name_input.nil?
      [nil]
    else
      Merchant.where('name ILIKE ?', "%#{name_input}%").order(:name)
    end
  end
end
