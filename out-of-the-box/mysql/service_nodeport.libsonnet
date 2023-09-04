local vars = import './vars.libsonnet';

local ports = [
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

  for p in vars.container_ports
];


function(instance)
  local item = {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: '%s-nodeport' % instance.name,
      namespace: vars.namespace,
      labels: {app: '%s-nodeport' % instance.name},
    },
    spec: {
      selector: {app: instance.name},
      type: "NodePort",
      ports: ports
    }
  };

  item