# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  belongs_to(:invoice)
  belongs_to(:item)
  has_many(:merchants, through: :item)
  has_many(:customers, through: :invoice)
  has_many(:transactions, through: :invoice)

  validates_numericality_of(:quantity)
  validates_numericality_of(:unit_price)
end
