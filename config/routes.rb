Rails.application.routes.draw do
  root 'deliveries#draft'
  resources :deliveries do
    collection do
      get 'draft'
      get 'active'
      get 'past'
    end
    resources :steps, controller: "deliveries/steps"
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
