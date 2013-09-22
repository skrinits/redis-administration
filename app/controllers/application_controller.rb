class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :check_exist_connection

    def redis
        RedisModel.redis
    end

    private 
        def check_exist_connection
            redirect_to(connection_login_path) unless RedisModel.redis
        end
end
