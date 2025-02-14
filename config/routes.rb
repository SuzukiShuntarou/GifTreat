Rails.application.routes.draw do
  root to: redirect('/goals')

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :rewards, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :goals, only: [:index, :edit, :update] do
    resources :likings, only: [:create]
    resources :cheerings, only: [:create]
  end
  get 'terms_service', to: 'welcome#terms_service'
  get 'privacy_policy', to: 'welcome#privacy_policy'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener" 
  end
end
