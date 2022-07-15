# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        # resources :find, controller: :search, only: %i[index]
        get 'find', to: 'search#index'
      end
      resources :merchants, only: %i[index show] do
        # collection do
        #   get 'find', to: 'search#index'
        # end
        resources :items, controller: :merchant_items, only: %i[index]
      end

      namespace :items do
        # resources :find, controller: :search, only: %i[index]
        get 'find_all', to: 'search#index'
      end
      resources :items, only: %i[index show create destroy update] do
        resources :merchant, controller: :item_merchant, only: %i[index]
      end
    end
  end
end
