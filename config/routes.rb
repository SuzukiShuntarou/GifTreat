Rails.application.routes.draw do
  devise_for :users
  resources :rewards, only: [:show, :new, :create, :edit, :update, :destroy]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener" 
  end
end
