Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "events#index"

  resources :events, only: [:index, :show] do
    post :upvote, to: "votes#upvote"
    post :downvote, to: "votes#downvote"
  end

  resource :session, only: [:create, :destroy]
end
