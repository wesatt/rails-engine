# frozen_string_literal: true

module Api
  module V1
    module Revenue
      class MerchantsController < ApplicationController
        def index
          merchants = Merchant.top_merchants_by_revenue(params[:quantity])
          render json: MerchantNameRevenueSerializer.new(merchants)
        end
      end
    end
  end
end
