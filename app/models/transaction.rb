# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to(:invoice)
  has_many(:customers, through: :invoice)
  has_many(:invoice_items, through: :invoice)
  has_many(:items, through: :invoice_items)
  has_many(:merchants, through: :items)

  validates_presence_of(:credit_card_number)
  validates_presence_of(:credit_card_expiration_date)
  validates_presence_of(:result)
end
