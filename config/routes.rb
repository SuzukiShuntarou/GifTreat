Rails.application.routes.draw do
  get "goals/index"
  get "goals/edit"
  devise_for :users
  resources :rewards, only: [:show, :new, :create, :edit, :update, :destroy]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener" 
  end
end
