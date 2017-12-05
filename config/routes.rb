Rails.application.routes.draw do
  # Sidekiq monitoring
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount Sidekiq::Web => '/sidekiq'
end
