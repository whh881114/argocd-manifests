{
  container_ports: [
      {name: 'http', containerPort: 8500},
      {name: 'serflan-tcp', containerPort: 8301},
      {name: 'serflan-udp', containerPort: 8301, protocol: 'UDP'},
      {name: 'consuldns', containerPort: 8600},
  ],

  requests_cpu: '100m',
  requests_memory: '64Mi',
  limits_cpu: '500m',
  limits_memory: '256Mi',

  config_name: 'consul-agent-config',
}