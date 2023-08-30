local vars = import './vars.libsonnet';

[
  {
    apiVersion: "rbac.authorization.k8s.io/v1",
    kind: "ClusterRoleBinding",
    metadata: {
      name: "%s-%s" % [vars['type'], instance['name']],
      namespace: vars['namespace'],
    },
    subjects: [{kind: "ServiceAccount", name: "%s-%s" % [vars['type'], instance['name']], namespace: vars['namespace']}],
    roleRef: {
      kind: "ClusterRole",
      name: "%s-%s" % [vars['type'], instance['name']],
      apiGroup: "rbac.authorization.k8s.io"
    }
  }

  for instance in vars['instances']
]