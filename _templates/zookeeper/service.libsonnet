function(app)
	local serviceCluster = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name,
	    labels: {app: app.name},
	  },
    spec: {
      selector: {app: app.name},
      type: 'ClusterIP',
      ports: [
        {name: 'client', port: 2181, targetPort: 2181},
        {name: 'server', port: 2888, targetPort: 2888},
        {name: 'leader-election', port: 3888, targetPort: 3888},
      ],
    },
  };

  local serviceNodePort = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-nodeport',
	    labels: {app: app.name + '-nodeport'},
	  },
    spec: {
      selector: {app: app.name},
      type: 'NodePort',
      ports: [
        {name: 'client', port: 2181, targetPort: 2181},
        {name: 'server', port: 2888, targetPort: 2888},
        {name: 'leader-election', port: 3888, targetPort: 3888},
      ],
    },
  };

  [serviceCluster, serviceNodePort]
