Rails.application.routes.draw do
  authenticated :user do
    root to: 'goals#index', as: :authenticated_root
  end

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :rewards, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :invitations, only:[:index]
  end
  resources :goals, only: [:index, :edit, :update] do
    resources :likings, only: [:create]
    resources :cheerings, only: [:create]
  end

  root 'welcome#index', as: :top_page
  get 'terms_service', to: 'welcome#terms_service'
  get 'privacy_policy', to: 'welcome#privacy_policy'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener" 
  end
end
