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

      def update
        item = Item.find(params[:id])
        if item.update(item_params)
          render json: ItemSerializer.new(item), status: :accepted
        else
          render json: ItemSerializer.new(item), status: :not_found
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
