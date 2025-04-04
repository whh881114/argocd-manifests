function(app)
	local serviceClusterController = [
		{
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-controller-' + i,
		    labels: {app: app.name + '-controller-' + i},
		  },
	    spec: {
	      selector: {app: app.name + '-controller-' + i},
	      type: 'ClusterIP',
	      ports: [
	        {
			      name: 'controller',
			      port: 9093,
			      targetPort: 9093,
	        },
	      ],
	    },
	  }
	  for i in std.range(0, app.controller.replicas-1)
  ];

  local serviceNodePortController = [
	  {
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-controller-' + i + '-nodeport',
		    labels: {app: app.name + '-controller-' + i + '-nodeport'},
		  },
	    spec: {
	      selector: {app: app.name + '-controller-' + i},
	      type: 'NodePort',
	      ports: [
	        {
			      name: 'controller',
			      port: 9093,
			      targetPort: 9093,
	        },
	      ],
	    },
	  }
    for i in std.range(0, app.controller.replicas-1)
  ];

	local serviceClusterBroker = [
		{
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-broker-' + i,
		    labels: {app: app.name + '-broker-' + i},
		  },
	    spec: {
	      selector: {app: app.name + '-broker-' + i},
	      type: 'ClusterIP',
	      ports: [
	        {
			      name: 'broker',
			      port: 9092,
			      targetPort: 9092,
	        },
	        {
			      name: 'broker-internal',
			      port: 19092,
			      targetPort: 19092,
	        },
	      ],
	    },
	  }
	  for i in std.range(0, app.broker.replicas-1)
  ];

  local serviceNodePortBroker = [
	  {
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-broker-' + i + '-nodeport',
		    labels: {app: app.name + '-broker-' + i + '-nodeport'},
		  },
	    spec: {
	      selector: {app: app.name + '-broker-' + i},
	      type: 'NodePort',
	      ports: [
	        {
			      name: 'broker',
			      port: 9092,
			      targetPort: 9092,
	        },
	        {
			      name: 'broker-internal',
			      port: 19092,
			      targetPort: 19092,
	        },
	      ],
	    },
	  }
	  for i in std.range(0, app.broker.replicas-1)
  ];

  local serviceClusterConsole = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-console',
	    labels: {app: app.name + '-console'},
	  },
    spec: {
      selector: {app: app.name + '-console'},
      type: 'ClusterIP',
      ports: [
        {
		      name: 'console',
		      port: 8080,
		      targetPort: 8080,
        },
      ],
    },
  };

  local serviceNodePortConsole = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-console-nodeport',
	    labels: {app: app.name + '-console-nodeport'},
	  },
    spec: {
      selector: {app: app.name + '-console'},
      type: 'NodePort',
      ports: [
        {
		      name: 'console',
		      port: 8080,
		      targetPort: 8080,
        },
      ],
    },
  };


  serviceClusterController +
  serviceNodePortController +
  serviceClusterBroker +
  serviceNodePortBroker +
  [serviceClusterConsole, serviceNodePortConsole]

