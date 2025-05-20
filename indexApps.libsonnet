[
    {name: 'default',           namespace: self.name, path: self.name,   project: 'default'},
    {name: '002-project-index', namespace: 'argocd',  path: '_projects', project: 'default'},

    {name: 'mysql',      namespace: self.name, path: self.name, project: 'database'},
    {name: 'redis',      namespace: self.name, path: self.name, project: 'database'},

    {name: 'kafka',      namespace: self.name, path: self.name, project: 'middleware'},
    {name: 'rocketmq',   namespace: self.name, path: self.name, project: 'middleware'},
    {name: 'zookeeper',  namespace: self.name, path: self.name, project: 'middleware'},

    {name: 'cert-manager-issuers', namespace: 'cert-manager',           path: self.name, project: 'system'},
    {name: 'argocd',       namespace: 'argocd',                 path: 'argocd',  project: 'system'},

    {name: 'monitoring',           namespace: self.name,      path: self.name, project: 'monitoring'},

    {name: 'jenkins-manifests',   namespace: 'jenkins',   path: 'jenkins', project: 'middleware'},

    {name: 'devops',   namespace: 'devops',   path: self.name, project: 'default'},

]
