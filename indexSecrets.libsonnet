[
		{name: 'cert-manager',             namespace: 'cert-manager',           path: self.name, project: 'secret',},
		{name: 'argocd-projects',          namespace: 'argocd',                 path: self.name, project: 'secret',},
		{name: 'ingress-nginx-baisc-auth', namespace: 'argocd',                 path: self.name, project: 'secret',},
    {name: 'kubernetes-dashboard',     namespace: 'kubernetes-dashboard',   path: self.name, project: 'secret',},
    {name: 'alertmanager',             namespace: 'monitoring',             path: self.name, project: 'secret',},
]
