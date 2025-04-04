function(app)
  local serviceMonitor = [
	  {
		  'apiVersion': 'monitoring.coreos.com/v1',
		  'kind': 'ServiceMonitor',
		  'metadata': {
		    'labels': {
		      'app': app.name + '-namesrv-' + i,
		    },
		    'name': app.name + '-namesrv-' + i,
		  },
		  'spec': {
		    'endpoints': [
		      {
		        'path': '/metrics',
		        'port': 'metrics'
		      },
		    ],
		    'selector': {
		      'matchLabels': {
		        'app': app.name + '-namesrv-' + i,
		      }
		    }
		  }
		}
		for i in std.range(0, app.nameSrv.replicas-1)
	];

	serviceMonitor