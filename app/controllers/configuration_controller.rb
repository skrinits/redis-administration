class ConfigurationController < ApplicationController
    def index
        @params = {general: ['loglevel', 'timeout'], snapshotting: ['save',
        'dbfilename', 'stop-writes-on-bgsave-error', 'rdbcompression', 'rdbchecksum'],
        'append only mode' => ['no-appendfsync-on-rewrite', 'appendfsync', 'appendonly',
        'auto-aof-rewrite-percentage', 'auto-aof-rewrite-min-size'], replication: ['masterauth',
        'slave-serve-stale-data', 'slave-read-only', 'slave-priority', 'repl-timeout', 'repl-ping-slave-period'],
        limits: ['maxmemory-policy', 'maxclients', 'maxmemory-samples', 'maxmemory'], 
        'advanced config' => ['client-output-buffer-limit', 'zset-max-ziplist-entries', 'zset-max-ziplist-value',
        'set-max-intset-entries', 'list-max-ziplist-entries', 'list-max-ziplist-value','hash-max-ziplist-entries',
        'hash-max-ziplist-value'], 'slow log' => ['slowlog-log-slower-than', 'slowlog-max-len'],
        'lua scripting' => ['lua-time-limit'], security: ['requirepass'] }

        @data  = redis.config(:get, '*')
    end

    def update
        if redis.config(:set, params[:param], params[:value]) == 'OK'
             render json: {value: params[:value], notice:  'Parameter successfully changed'}
        else
            render json: {value: params[:value], error:  'Invalid parameter'}
        end
    rescue Exception => e
        render json: {value: params[:value], error:  e.message}
    end
end
