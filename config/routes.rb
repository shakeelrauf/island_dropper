Rails.application.routes.draw do
  require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
  namespace :admin do
    get 'dashboard/index'
  end

  root 'deliveries#active'
  resources :deliveries, param: :token do
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
      post 'job_cclosed'
      post 'job_completed'
      post 'job_driveratpickup'
      post 'job_onway'
      post 'job_driveratdropoff'
      post 'job_abandoned'
      post 'job_edited'
    end
  end
  namespace :admin do
    get 'dashboard'
    get 'profile'
    resources :jobs, only: [:index]
    resources :pricing, only: [:index, :update,:get]
    resources :users, only: [:index]
    get 'data_query'
  end


  devise_for :users, controllers: { confirmations: 'confirmations' , sessions: 'sessions', registrations: 'registrations'} 
  devise_scope :user do  
    get 'registrations/email_confirmation', to: 'registrations#email_confirmation'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
