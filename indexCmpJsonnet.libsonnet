[
  {name: 'argocd-cmp-jsonnet-nginx-1', path:'argocd-cmp-jsonnet/nginx-1', jsonnetFile: 'index.jsonnet', namespace: 'nginx', project: 'default', registry: {project: 'docker.io', image: 'library/nginx', tag: 'latest'},},
  {name: 'argocd-cmp-jsonnet-nginx-2', path:'argocd-cmp-jsonnet/nginx-2', jsonnetFile: 'index.jsonnet', namespace: 'nginx', project: 'default', registry: {project: 'docker.io', image: 'library/nginx', tag: 'latest'},},
  {name: 'argocd-cmp-jsonnet-nginx-3', path:'argocd-cmp-jsonnet/nginx-3', jsonnetFile: 'index.jsonnet', namespace: 'nginx', project: 'default', registry: {project: 'docker.io', image: 'library/nginx', tag: 'latest'},},
  {name: 'argocd-cmp-jsonnet-nginx-4', path:'argocd-cmp-jsonnet/nginx-4', jsonnetFile: 'index.jsonnet', namespace: 'nginx', project: 'default', registry: {project: 'docker.io', image: 'library/nginx', tag: 'latest'},},

  {name: 'simple-java-maven-app', path:'simple-java-maven-app', jsonnetFile: 'index.jsonnet', namespace: 'default', project: 'default', registry: {project: 'library', image: 'simple-java-maven-app', tag: 'latest'},},
]
