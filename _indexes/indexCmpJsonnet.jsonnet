# https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/

local apps = import '../indexCmpJsonnet.libsonnet';
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
        repoURL: clusterParams.repo.app.url,
        targetRevision: clusterParams.repo.app.branch,
        path: app.path,
        plugin: {
          name: 'argocd-cmp-jsonnet',
          parameters: [
            {
              name: 'jsonnet-file',   # pluging中定义了jsonnet-file参数，所以此处是固定值
              string: app.jsonnetFile
            },
            {
              name: 'registry',
              string: 'harbor.idc.roywong.work',
            },
            {
              name: 'project',
              string: app.registry.project,
            },
            {
              name: 'image',
              string: app.registry.image,
            },
            {
              name: 'tag',
              string: app.registry.tag,
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

  for app in apps
]