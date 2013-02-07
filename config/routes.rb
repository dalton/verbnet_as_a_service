VerbnetAsAService::Application.routes.draw do
  root :to => "home#index"
  match "/ingest", to: 'home#ingest', as: :ingest, method: :post
  match "/check", to: 'verbnet_classes#check', as: :check
  resources :verbnet_classes, only: [:index, :show]
  resources :selectional_restriction_types
end
