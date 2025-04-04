# https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/

local projects = import './projects.libsonnet';
local clusterParams = import '../clusterParams.libsonnet';

[
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'AppProject',
    metadata: {
      name: project.name,
      namespace: clusterParams.argocdNamespace,
    },
    spec: {
      clusterResourceWhitelist: [
        {group: '*', kind: '*'},
      ],
      destinations: [
        { name: 'in-cluster', namespace: '*', server: 'https://kubernetes.default.svc'},
      ],
      namespaceResourceWhitelist: [
        {group: '*', kind: '*'},
      ],
      sourceRepos: [
        '*',
      ]
    }
  }

  for project in projects
]
