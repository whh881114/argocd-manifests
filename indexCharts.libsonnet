[
		{name: 'storageclass-nfs-infra', version: '4.0.18', path:'/_charts/nfs-subdir-external-provisioner/' + self.version, namespace: 'storageclass', valueFiles: ['values-infra.yaml'], project: 'system'},
		{name: 'storageclass-nfs-mysql', version: '4.0.18', path:'/_charts/nfs-subdir-external-provisioner/' + self.version, namespace: 'storageclass', valueFiles: ['values-mysql.yaml'], project: 'system'},
		{name: 'storageclass-nfs-redis', version: '4.0.18', path:'/_charts/nfs-subdir-external-provisioner/' + self.version, namespace: 'storageclass', valueFiles: ['values-redis.yaml'], project: 'system'},

		{name: 'cert-manager', version: '1.15.2', path:'/_charts/cert-manager/' + self.version, namespace: 'cert-manager', valueFiles: ['values.yaml'], project: 'system'},

		{name: 'ingress-nginx-wan', version: '4.12.0', path:'/_charts/ingress-nginx/' + self.version, namespace: 'ingress-nginx', valueFiles: ['values-wan.yaml'], project: 'system'},
		{name: 'ingress-nginx-lan', version: '4.12.0', path:'/_charts/ingress-nginx/' + self.version, namespace: 'ingress-nginx', valueFiles: ['values-lan.yaml'], project: 'system'},

		{name: 'istio-base',        version: '1.23.0', path:'/_charts/istio/' + self.version + '/base',    namespace: 'istio-system', valueFiles: ['values.yaml'],      project: 'system'},
		{name: 'istio-istiod',      version: '1.23.0', path:'/_charts/istio/' + self.version + '/istiod',  namespace: 'istio-system', valueFiles: ['values.yaml' ],     project: 'system'},
		{name: 'istio-gateway-lan', version: '1.23.0', path:'/_charts/istio/' + self.version + '/gateway', namespace: 'istio-system', valueFiles: ['values-lan.yaml'],  project: 'system'},
    {name: 'istio-gateway-wan', version: '1.23.0', path:'/_charts/istio/' + self.version + '/gateway', namespace: 'istio-system', valueFiles: ['values-wan.yaml' ], project: 'system'},

		{name: 'prometheus', version: '61.8.0',  path:'/_charts/kube-prometheus-stack/' + self.version, namespace: 'monitoring', valueFiles: ['values.yaml'], project: 'monitoring'},
		{name: 'thanos',     version: '15.7.19', path:'/_charts/' + self.name + '/' + self.version,     namespace: 'monitoring', valueFiles: ['values.yaml'], project: 'monitoring'},
]
