local func_vars = import './vars.libsonnet';


function(instance)
  local vars = func_vars(instance);

  local item = {
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'ServiceMonitor',
    metadata: {
      name: instance.name,
      namespace: vars.namespace,
      labels: {app: instance.name},
    },
    spec: {
      namespaceSelector: {matchNames: [vars.namespace]},
      selector: {matchLabels: {app: instance.name}},
      endpoints: [{path: '/metrics', port: 'metrics'}]
    }
  };

  item