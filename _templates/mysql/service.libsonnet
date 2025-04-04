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
		      name: 'mysql',
		      port: 3306,
		      targetPort: 3306,
        },
        {
		      name: 'metrics',
		      port: 9104,
		      targetPort: 9104,
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
		      name: 'mysql',
		      port: 3306,
		      targetPort: 3306,
        },
        {
		      name: 'metrics',
		      port: 9104,
		      targetPort: 9104,
        },
      ],
    },
  };

  [serviceCluster, serviceNodePort]
