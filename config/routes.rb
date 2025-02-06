Rails.application.routes.draw do
  root to: redirect('/goals')

  devise_for :users
  resources :rewards, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :goals, only: [:index, :edit, :update]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener" 
  end
end
