function(app)
	local pvcController = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  'data-' + app.name + '-controller-' + i,
		    labels: {app: 'data-' + app.name + '-controller-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources: {requests: {storage: app.storageClassCapacity}},
	      storageClassName: app.storageClassName,
	    },
    }
    for i in std.range(0, app.controller.replicas-1)
  ];

  local pvcBroker = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  'data-' + app.name + '-broker-' + i,
		    labels: {app: 'data-' + app.name + '-broker-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources: {requests: {storage: app.storageClassCapacity}},
	      storageClassName: app.storageClassName,
	    },
    }
    for i in std.range(0, app.broker.replicas-1)
  ];

	pvcController + pvcBroker


