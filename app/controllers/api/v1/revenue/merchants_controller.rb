# frozen_string_literal: true

module Api
  module V1
    module Revenue
      class MerchantsController < ApplicationController
        def index
          merchants = Merchant.top_merchants_by_qty(params[:quantity])
          # x = json: MerchantNameRevenueSerializer.new(merchants)
          # binding.pry
          render json: MerchantNameRevenueSerializer.new(merchants)
        end
      end
    end
  end
end
