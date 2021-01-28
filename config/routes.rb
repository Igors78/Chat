# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :channels do
    resource :channel_user
    resources :messages
  end
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'channels#index'
  
end
