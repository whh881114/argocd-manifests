function(app)
	local pvcNameSrv = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  'logs-' + app.name + '-namesrv-' + i,
		    labels: {app: 'logs-' + app.name + '-namesrv-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources: {requests: {storage: app.logsStorageClassCapacity}},
	      storageClassName: app.storageClassName,
	    },
    }
    for i in std.range(0, app.nameSrv.replicas-1)
  ];

  local pvcBroker = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  type + '-' + app.name + '-' + i,
		    labels: {app: type + '-' + app.name + '-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources:
		      if type == 'data' then
		        {requests: {storage: app.dataStorageClassCapacity}}
			    else
						{requests: {storage: app.logsStorageClassCapacity}},
	      storageClassName: app.storageClassName,
	    },
    }
    for i in [app.brokerM1.name, app.brokerS1.name, app.brokerM2.name, app.brokerS2.name]
    for type in ['data', 'logs']
  ];

	pvcNameSrv + pvcBroker


