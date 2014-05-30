class StatisticsController < ApplicationController
  before_action do
    @params = {server: [:uptime_in_seconds, :uptime_in_days, :lru_clock],
          clients: [:connected_clients, :client_longest_output_list, :client_biggest_input_buf,
                   :blocked_clients],
          memory: [:used_memory, :used_memory_human, :used_memory_rss,
                  :used_memory_peak, :used_memory_peak_human,
                  :used_memory_lua, :mem_fragmentation_ratio,
                  :mem_allocator],
          replication:[:role, :connected_slaves],
          cpu: [:used_cpu_sys, :used_cpu_user, :used_cpu_sys_children, :used_cpu_user_children],
          persistence: [:loading, :rdb_changes_since_last_save, :rdb_bgsave_in_progress,
                    :rdb_last_save_time, :rdb_last_bgsave_status, :rdb_last_bgsave_time_sec,
                    :rdb_current_bgsave_time_sec, :aof_enabled, :aof_rewrite_in_progress,
                    :aof_rewrite_scheduled, :aof_last_rewrite_time_sec,
                    :aof_current_rewrite_time_sec, :aof_last_bgrewrite_status],
          stats: [:total_connections_received, :total_commands_processed,
               :instantaneous_ops_per_sec, :rejected_connections,
               :expired_keys, :evicted_keys, :keyspace_hits, :keyspace_misses,
               :pubsub_channels, :pubsub_patterns, :latest_fork_usec],
          keyspace: [ :db0]
    }    
  end

  def index
    get_info
  end

  def destroy
    case params[:type]
      when 'all' 
        redis.config :resetstat
      when 'slowlog'
        redis.slowlog :reset
    end
    get_info
    redirect_to statistics_path(anchor: 'slowlog')
  end

  private
    def get_info
      @info = redis.info
      @slowlog = redis.slowlog :get
    end
end
