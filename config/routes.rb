Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  get "analytics" => "analytics#index"

  resources :imports, only: %i[new create]

  resources :mous do
    resources :outcomes do
      resources :feedbacks, except: %i[index show]
    end
  end
end
