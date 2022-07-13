# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        item = Item.find(params[:id])
        render json: ItemSerializer.new(item)
      end

      def create
        item = Item.create(item_params)
        render json: ItemSerializer.new(item), status: :created
      end

      def destroy
        item = Item.find(params[:id])
        Item.destroy(params[:id])
        render json: ItemSerializer.new(item), status: :ok
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
