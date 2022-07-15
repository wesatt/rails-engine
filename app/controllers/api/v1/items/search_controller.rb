# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          if query_validator
            items = Item.find_all(item_search_params)
            render json: ItemSerializer.new(items)
          else
            render json: ItemSerializer.new([])
          end
        end

        private

        def item_search_params
          params.permit(:name, :min_price, :max_price)
        end

        def query_validator
          name = !params[:name].nil? && (params[:name] != '')
          min = !params[:min_price].nil?
          max = !params[:max_price].nil?
          (
            (name && !min && !max) ||
            (!name && (min || max))
          )
        end
      end
    end
  end
end
