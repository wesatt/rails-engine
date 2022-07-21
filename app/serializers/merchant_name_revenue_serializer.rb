# frozen_string_literal: true

class MerchantNameRevenueSerializer
  include JSONAPI::Serializer
  attributes :name, :revenue

  # attributes :revenue do |merchant|
  #   merchant.revenue
  # end
end
