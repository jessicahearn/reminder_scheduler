Rails.application.routes.draw do
  
  root "reminders#index"
  devise_for :users
  resources :reminders

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
