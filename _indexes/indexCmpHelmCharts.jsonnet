# https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/

local indexCmpHelmCharts = import '../indexCmpHelmCharts.libsonnet';
local clusterParams = import '../clusterParams.libsonnet';

[
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: chart.name,
      namespace: clusterParams.argocdNamespace,
      annotations: {
        'argocd.argoproj.io/refresh': 'hard',
      },
    },
    spec: {
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: chart.namespace,
      },
      project: chart.project,
      source: {
        repoURL: clusterParams.repo.app.url,
        targetRevision: clusterParams.repo.app.branch,
        path: chart.path,
        plugin: {
          name: 'argocd-cmp-helm',
          parameters: [
            {
              name: 'jsonnet-file',   # pluging中定义了jsonnet-file参数，所以此处是固定值
              string: chart.valueFiles
            },
          ]
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

  for chart in indexCmpHelmCharts
]