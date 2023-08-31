{
  # 基础设施
  coredns_ip: '172.16.0.10',
  domain_name: 'k8s.bj.freedom.org',
  busybox_image: 'harbor.freedom.org/docker.io/busybox:1.31.1',
  image_pull_policy: 'IfNotPresent',

  # consul相关变量
  consul_namespace: 'consul',
  consul_datacenter: 'bj',
  consul_image: 'harbor.freedom.org/docker.io/consul:1.10.2',

  consul_server_args_retry_json: ['consul-server-0.consul-server.$(NAMESPACE).svc.cluster.local',
                             'consul-server-1.consul-server.$(NAMESPACE).svc.cluster.local',
                             'consul-server-2.consul-server.$(NAMESPACE).svc.cluster.local'],
}