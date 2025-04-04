# https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/

local indexSecrets = import '../indexSecrets.libsonnet';
local clusterParams = import '../clusterParams.libsonnet';

[
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: secret.name + '-secrets',
      namespace: clusterParams.argocdNamespace,
    },
    spec: {
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: secret.namespace,
      },
      project: secret.project,
      source: {
        repoURL: clusterParams.repoSecrets.url,
        targetRevision: clusterParams.repoSecrets.branch,
        path: secret.path,
        directory: {
          jsonnet: {},
          recurse: true,
        },
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

  for secret in indexSecrets
]