Rails.application.routes.draw do
  # get '/robots.txt', to: 'seo#robots'
  # get '/sitemap.xml', to: 'seo#sitemap', format: 'xml'
  require 'sidekiq/web'
  require 'constraints/admin_constraint'

  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint

  scope module: :web do
    root 'welcome#index'

    get '/about', to: 'static_pages#about'
    get '/contributors', to: 'static_pages#contributors'
    get '/terms', to: 'static_pages#terms'
    get '/contact_us', to: 'static_pages#contact_us'

    resources :jobs, except: [:index]
    resources :tags, only: [:index]
    resource :subscription, only: [:new, :create, :destroy]

    scope module: :auth do
      get '/login', to: 'user_sessions#new', as: :login
      post '/logout', to: 'user_sessions#destroy', as: :logout
      resources :user_sessions, only: :create

      get '/signup', to: 'users#new', as: :signup
      resources :users, except: [:new, :index, :show]

      post 'oauth/callback' => 'oauths#callback'
      get 'oauth/callback' => 'oauths#callback'
      get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider
    end

    namespace :admin do
      root 'dashboard#index'
      resources :users, only: %i[index edit update destroy]
      resources :subscriptions, only: :index
      resources :jobs, only: %i[index edit update destroy] do
        post 'approve', on: :member
        post 'not_approve', on: :member
      end
    end
  end
end
