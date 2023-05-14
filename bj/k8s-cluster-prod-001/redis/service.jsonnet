local vars = import './vars.libsonnet';
local standalone_instances = import './standalone/vars.libsonnet';
local cluster_instances = import './cluster/vars.libsonnet';

local ports_standalone = [
    if "protocol" in p then
    {
      name: p.name,
      port: p.containerPort,
      targetPort: p.containerPort,
      protocol: p.protocol
    }
    else
    {
      name: p.name,
      port: p.containerPort,
      targetPort: p.containerPort,
    }

    for p in standalone_instances['container_ports']
];


local ports_cluster = [
    if "protocol" in p then
    {
      name: p.name,
      port: p.containerPort,
      targetPort: p.containerPort,
      protocol: p.protocol
    }
    else
    [
      {
        name: p.name,
        port: p.containerPort,
        targetPort: p.containerPort,
      }
    ]

    for p in cluster_instances['container_ports']
];


local cluster_services = [
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: if service_type == "ClusterIP" then "%s-%d" % [instance['name'], num] else "%s-%s-%d" % [instance['name'], std.asciiLower(service_type), num],
      namespace: vars['namespace'],
      labels: {app: instance['name']},
    },
    spec: {
      selector: {app: instance['name']},
      type: "%s" % service_type,
      ports: ports_cluster
    }
  }

  for service_type in ["ClusterIP", "NodePort"]
  for instance in cluster_instances['instances']
  for num in std.range(1, instance['replicas'])
];



[
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: if service_type == "ClusterIP" then instance['name'] else "%s-%s" % [instance['name'], std.asciiLower(service_type)],
      namespace: vars['namespace'],
      labels: {app: instance['name']},
    },
    spec: {
      selector: {app: instance['name']},
      type: "%s" % service_type,
      ports: ports_standalone
    }
  }

  for instance in standalone_instances['instances']
  for service_type in ["ClusterIP", "NodePort"]
] + cluster_services