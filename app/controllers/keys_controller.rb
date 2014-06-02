require 'json'

class KeysController < ApplicationController
  def index               
    if params[:db_id]
      $redis.select params[:db_id]      
      session[:db_index] = params[:db_id] .to_i
    end   
    respond_to do |format| 
      format.html{ 
        @dbs= redis.config(:get, :databases)["databases"].to_i
        @dbs = @dbs.zero? ? 12 : @dbs
        @db_index = session[:db_index] || 0 
        @keys = {}
        $redis.keys.map do |key|
          parts = key.split(':')
          @keys[parts[0]] = {isParent: parts.length > 1, title: parts[0]}
        end
        @keys = @keys.values
        render :index
      }
      format.json{
        data = {}
        current_index = params[:id].split(':').length
        redis.keys(params[:id] + ':*').each do |key|
          parts = key.split(':')
          is_parent = !(parts.length == current_index + 1)
          key = parts.slice(0, current_index + 1).join(':')
          unless data.has_key? key
            data[key] = {id: key, isParent: is_parent}
          end
        end
        render json: data.values
      }

    end
  end

  def show
    key = params[:id]
    type = redis.type key 
    content = case type 
                when 'string'
                  redis.get key
                when 'hash'
                  redis.hgetall key
                when 'list'
                  len = redis.llen key
                  redis.lrange key, 0, len - 1
                when 'set'
                  redis.smembers key
                when 'zset'
                  max = redis.zcard key
                  redis.zrevrange(key, 0, max)
              end
    render json: {type: type, content: content.to_json}
  end

  def create

  end

  def update
    begin
      if params[:type] == 'string'
        redis.set(params[:id], params[:content]) 
      else
        redis.del params[:id]
        content = JSON.parse(params[:content])
        content.each do |key, value|
          case params[:type] 
            when 'hash'
              redis.hset(params[:id], key, value)
            when 'list'
              redis.rpush(params[:id], key)
            when 'set'
              redis.sadd(params[:id], key)
            when 'zset' 
              redis.zadd(params[:id], key)        
          end          
        end
      end
      render json: {success: "Key '#{params[:id]}' has been updated"}
    rescue Exception => e
      render json: {error: "Error: #{e.message}"}
    end    
  end

  def destroy
    case params[:type]
      when 'flushdb'
        redis.flushdb
        message = "Db '#{session[:db_index]}' has been flushed"  
      when 'key'
        redis.del params[:key]
        message = "Key '#{params[:key]}' has been deleted"  
    end        
    render text: message
  end
end
