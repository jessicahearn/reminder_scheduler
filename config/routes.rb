Rails.application.routes.draw do
  
  root "reminders#index"
  devise_for :users
  resources :reminders
end
