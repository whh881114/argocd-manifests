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
        path: clusterParams.appRootDir + '/' + app.path,
        directory: {
          jsonnet: {},
          recurse: true,
        },
        repoURL: clusterParams.repo.url,
        targetRevision: clusterParams.repo.branch,
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
