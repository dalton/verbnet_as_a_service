VerbnetAsAService::Application.routes.draw do
  root :to => "home#index"
  resources :verbnet_classes, only: [:show]
end
