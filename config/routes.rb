Rails.application.routes.draw do
  devise_for :admins, controllers: {
    registrations: 'admins/registrations'
}
  get "categories/index"
  get "categories/new"
  get "categories/create"
  get "categories/edit"
  get "categories/update"
  get "categories/destroy"
  resources :users
  resources :packages do
    member do
      post :send_package
      post :collect_package
      put 'update_payment_status'
    end
    collection do
      get 'search', as: 'search'
    end

    post 'process_collection', on: :collection

  end
  resources :transactions

  resources :categories

  resources :categories do
    get 'pricing_details', on: :member
  end

  resources :cities

  root 'packages#index'  # Set root route to packages for now
end
