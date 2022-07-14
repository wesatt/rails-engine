class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchant = Merchant.find_by_name(params[:name]).first
    if merchant.nil?
      render json: {data: {}}, status: :ok
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
