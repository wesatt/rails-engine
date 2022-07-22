# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.format_merchants(Merchant.all)
      end

      def show
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
      end

      def most_items
        merchants = Merchant.top_merchants_by_items(params[:quantity])
        render json: MerchantNameCountSerializer.new(merchants)
      end
    end
  end
end
