# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      # namespace :merchants do
      #   resources :find, controller: :search, only %i[index]
      # end
      # get '/merchants/find', 'search#index'
      resources :merchants, only: %i[index show] do
        resources :items, controller: :merchant_items, only: %i[index]
      end

      resources :items, only: %i[index show]
    end
  end
end
