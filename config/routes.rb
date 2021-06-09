Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :customer_subscription, only: [:create]
    end
  end

end
