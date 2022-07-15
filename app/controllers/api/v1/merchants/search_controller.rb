# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          merchant = Merchant.find_by_name(params[:name]).first
          if merchant.nil?
            render json: { data: {} }, status: :ok
          else
            render json: MerchantSerializer.new(merchant)
          end
        end
      end
    end
  end
end
