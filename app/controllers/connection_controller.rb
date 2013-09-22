class ConnectionController < ApplicationController
    skip_before_filter :check_exist_connection
    
    def login
        if request.get?
            render :login
        else
            respond_to do |format|
                host = params[:host].empty? ? '127.0.0.1' : params[:host]
                port = params[:port].empty? ? 6379 : params[:port].to_i
                RedisModel.initialize_connection(host, port, params[:password])
                format.html{redirect_to statistics_url}
            end
        end
    end

    def logout
        RedisModel.destroy_connection
        respond_to do |format|
            format.html{redirect_to connection_login_url}
        end
    end
end
