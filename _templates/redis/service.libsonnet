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
        {
		      name: 'redis',
		      port: 6379,
		      targetPort: 6379,
        },
        {
		      name: 'metrics',
		      port: 9121,
		      targetPort: 9121,
        },
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
        {
		      name: 'redis',
		      port: 6379,
		      targetPort: 6379,
        },
        {
		      name: 'metrics',
		      port: 9121,
		      targetPort: 9121,
        },
      ],
    },
  };

  [serviceCluster, serviceNodePort]
