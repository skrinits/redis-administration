class RedisModel < ActiveRecord::Base
    self.abstract_class = true

    class << self
        def initialize_connection(host = '127.0.0.1', port = 6379, password = '')
            unless $redis
                $redis = Redis.new(host: host, port: port)
                $redis.auth(password) unless password.empty?
            end
            unless password.empty?
                $redis.auth(password)
            end
            $redis
        end

        def destroy_connection
            if $redis
                $redis.quit 
                true
            else
                false
            end
        end

        def redis
            $redis
        end
    end
end