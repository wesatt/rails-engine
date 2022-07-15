# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to(:merchant)
  has_many(:invoice_items)
  has_many(:invoices, through: :invoice_items)
  has_many(:customers, through: :invoices)
  has_many(:transactions, through: :invoices)

  validates_presence_of(:name)
  validates_presence_of(:description)
  validates_numericality_of(:unit_price)

  def self.find_all(params)
    name = params[:name]
    min = params[:min_price]
    max = params[:max_price]
    if name
      Item.where('name ILIKE ?', "%#{name}%").order(:name)
    elsif min && max
      Item.where('unit_price >= ? AND unit_price <= ?', min, max)
    elsif min
      Item.where('unit_price >= ?', min)
    elsif max
      Item.where('unit_price <= ?', max)
    end
  end
end
