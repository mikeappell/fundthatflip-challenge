Rails.application.routes.draw do
  # Sidekiq monitoring
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount Sidekiq::Web => '/sidekiq'

  root to: 'data_points#index'

  namespace :api do
    namespace :v1 do
      resources :data_points, only: [:index]
    end
  end
end
