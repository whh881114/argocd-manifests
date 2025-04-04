function(app)
	local pvc = {
	  apiVersion: 'v1',
	  kind: 'PersistentVolumeClaim',
	  metadata: {
	    name:  'data-' + app.name,
	    labels: {app: app.name},
	  },
    spec: {
      accessModes: ["ReadWriteOnce"],
      resources: {
        requests: { storage: app.storageClassCapacity },
      },
      storageClassName: app.storageClassName,
    },
  };

  pvc