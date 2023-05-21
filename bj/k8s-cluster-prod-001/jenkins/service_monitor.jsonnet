local vars = import './vars.libsonnet';

[
  {
    apiVersion: "monitoring.coreos.com/v1",
    kind: "ServiceMonitor",
    metadata: {
      name: instance['name'],
      namespace: vars['namespace'],
      labels: {app: instance['name']},
    },
    spec: {
      namespaceSelector: {matchNames: [vars['namespace']]},
      selector: {matchLabels: {app: instance['name']}},
      endpoints: [
        {path: "/metrics", port: "metrics"}
      ]
    }
  }

  for instance in vars['instances']
]