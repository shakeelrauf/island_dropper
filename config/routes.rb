Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard/index'
  end

  root 'deliveries#active'
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
    get 'delivery_jobs'
    get 'pricing'
    put 'update_pricing'
    get 'user_accounts'
    get 'data_query'
  end


  devise_for :users, controllers: { confirmations: 'confirmations' , sessions: 'sessions', registrations: 'registrations'} 
  devise_scope :user do  
    get 'registrations/email_confirmation', to: 'registrations#email_confirmation'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
