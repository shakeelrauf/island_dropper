Rails.application.routes.draw do
  root 'deliveries#draft'
  resources :deliveries do
    collection do
      get 'draft'
      get 'active'
      get 'past'
      post 'complet'
    end
    member do
      post 'cancel'
    end
    resources :steps, controller: "deliveries/steps"
  end

  resources :webhooks do
    collection do 
      post 'job_accept'
      post 'job_cancelled'
    end
  end
  devise_for :users, controllers: { confirmations: 'confirmations' , sessions: 'sessions', registrations: 'registrations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
