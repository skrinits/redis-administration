RedisAdministration::Application.routes.draw do
    root 'connection#login'
    #statistics
    resources :statistics, only: [:index]
    patch '/statistics' => 'statistics#update'
    #configuration
    resources :configuration, only: [:index]
    patch '/configuration' => 'configuration#update'
    #terminal
    resources :terminal, only: [:index]
    get '/terminal/command' => 'terminal#show'
    #keys
    resources :keys, only: [:index, :edit, :update]
    delete '/keys/flushdb/:id' => 'keys#destroy_db'
    delete '/keys/del' => 'keys#destroy'
    get '/key/content' => 'keys#show'
    #connection
    get "connection/logout"
    get "connection/login"
    post "connection/login"
end
