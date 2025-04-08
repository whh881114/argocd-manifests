# https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/

local indexApps = import '../indexApps.libsonnet';
local clusterParams = import '../clusterParams.libsonnet';

[
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: app.name,
      namespace: clusterParams.argocdNamespace,
    },
    spec: {
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: app.namespace,
      },
      project: app.project,
      source: {
        path: app.path,
        directory: {
          jsonnet: {},
          recurse: true,
        },
        repoURL: clusterParams.repo.app.url,
        targetRevision: clusterParams.repo.app.branch,
      },
      syncPolicy: {
        syncOptions: [
          'CreateNamespace=true'
        ],
        # automated: {
        #   prune: 'true',
        #   selfHeal: 'true',
        # },
      },
    },
  }

  for app in indexApps
]
