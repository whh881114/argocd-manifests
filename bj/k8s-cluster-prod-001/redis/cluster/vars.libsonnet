// 当定义其他redis实例的配置文件时，请按照default_conf模板修改。
// 另外，要注意的是，requirepass和 maxmemory需要保留格式，他们分别对应的值写在instances中即可。
local other_conf = |||
  Here is the customized configuration content, adjusting to other mysql instances.
  ...
  ...
  requirepass [indiviual_redis_password]
  maxmemory [indiviual_redis_memory]
  ...
  ...
|||;

{
  container_ports: [
    {name: "redis", containerPort: 6379},
    {name: "cluster", containerPort: 16379},
  ],


  instances: [
    {
      name: "public",
      replicas: 6,
      memory: "4096Mi",
      limits_memory: self.memory,
      password: "uuglwtvYitnod@yevuqrDkr6xrlk3ach",
      disable: true
    },
  ],


  default_conf: |||
    dir /data
    bind 0.0.0.0
    cluster-enabled yes
    cluster-config-file nodes.conf
    logfile redis.log
    cluster-node-timeout 5000
    appendonly yes
    daemonize no
    pidfile redis.pid
    appendfilename appendonly.aof
    protected-mode yes
    \n
    maxmemory [indiviual_redis_memory]
    maxmemory-policy volatile-ttl
    \n
    requirepass [indiviual_redis_password]
    masterauth  [indiviual_redis_password]
    \n
    timeout 60
    tcp-keepalive 300
    loglevel notice
    \n
    appendfsync everysec
    no-appendfsync-on-rewrite no
    auto-aof-rewrite-percentage 100
    auto-aof-rewrite-min-size 64mb
    aof-load-truncated yes
    \n
    lua-time-limit 5000
    slowlog-log-slower-than 10000
    slowlog-max-len 128
    latency-monitor-threshold 0
    notify-keyspace-events ""
    hash-max-ziplist-entries 512
    hash-max-ziplist-value 64
    list-max-ziplist-entries 512
    list-max-ziplist-value 64
    set-max-intset-entries 512
    zset-max-ziplist-entries 128
    zset-max-ziplist-value 64
    hll-sparse-max-bytes 3000
    activerehashing yes
    client-output-buffer-limit normal 0 0 0
    client-output-buffer-limit slave 256mb 64mb 60
    client-output-buffer-limit pubsub 32mb 8mb 60
    hz 10
    aof-rewrite-incremental-fsync yes
  |||,
}