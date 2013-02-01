VerbnetAsAService::Application.routes.draw do
  root :to => "home#index"
  match "/ingest", to: 'home#ingest', as: :ingest, method: :post
  resources :verbnet_classes, only: [:show]
  resources :selectional_restriction_types
end
