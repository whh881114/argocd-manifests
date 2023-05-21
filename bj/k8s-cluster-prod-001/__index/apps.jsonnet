local vars = import './vars.libsonnet';

[
  {
    apiVersion: "argoproj.io/v1alpha1",
    kind: "Application",
    metadata: {
      name: instance['name'],
      namespace: "argocd",
    },
    spec: {
      destination: {
        name: "",
        namespace: "",
        server: "https://kubernetes.default.svc",
      },
      source: {
        path: instance['path'],
        repoURL: "git@github.com:whh881114/argocd-manifests.git",
        targetRevision: "master",
        directory: {recurse: true},
      },
      sources: [],
      project: "default",
      syncPolicy: {
        syncOptions: ["CreateNamespace=true"]
      }
    }
  }

  for instance in vars['instances']
]