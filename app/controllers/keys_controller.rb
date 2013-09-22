class KeysController < ApplicationController
    def index               
        if params[:db_id]
            $redis.select params[:db_id]      
            session[:db_index] = params[:db_id] .to_i
        end   
        respond_to do |format| 
            format.html{ 
                @dbs= redis.config(:get, :databases)["databases"].to_i
                @db_index = session[:db_index] || 0     
                render :index
            }
            format.json{
                pattern = params[:key] ? params[:key] + '*' : '*'
                data = []
                session[:current_id]  = 0 unless params[:key]

             redis.keys(pattern).each do |key|
                    offset = params[:key] ? params[:key].length + 1 : 0
                    end_slice = key.index(':', offset) || key.size()
                    root= !(end_slice == key.size())
                    data.push({label: key.slice(offset , end_slice - offset), id: session[:current_id], root: root, children: []})
                    session[:current_id] += 1
                end
                render json: data
            }

        end
    end

    def show
        key = params[:key]
        type = redis.type key       
         content = if type == 'string'
                            redis.get key
                        elsif type == 'hash'
                            redis.hgetall key
                        elsif type == 'list'
                            len = redis.llen key
                            redis.lrange key, 0, len - 1
                        elsif type == 'set'
                            redis.smembers key
                        elsif type == 'zset'
                            max = redis.zcard key
                            content = redis.zrevrange(key, 0, max)
                        end       
        render text: content
    end

    def edit
    end

    def update

    end

    def destroy
        redis.del params[:key]
        head :ok
    end

    def destroy_db
        redis.flushdb    
        head :ok
    end
end
