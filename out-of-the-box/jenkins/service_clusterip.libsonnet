local func_vars = import './vars.libsonnet';


function(instance)
  local vars = func_vars(instance);
  local ports = [
    if 'protocol' in p then
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

  local item = {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: instance.name,
      namespace: vars.namespace,
      labels: {app: instance.name},
    },
    spec: {
      selector: {app: instance.name},
      type: 'ClusterIP',
      ports: ports
    }
  };

  item