RedisAdministration::Application.routes.draw do
    root 'connection#login'
    #statistics
    resources :statistics, only: [:index]
    delete "statistics/reset/:type" => 'statistics#destroy', as: :statistics_reset
    #configuration
    resources :configuration, only: [:index]
    patch '/configuration' => 'configuration#update'
    #terminal
    resources :terminal, only: [:index]
    get '/terminal/command' => 'terminal#show'
    #keys
    resources :keys, only: [:index, :update, :create, :show]
    delete '/keys/destroy/:type(/:key)' => 'keys#destroy'
    #connection
    get "connection/logout"
    get "connection/login"
    post "connection/login"
end
