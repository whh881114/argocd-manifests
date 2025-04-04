function(app)
  local serviceMonitor = {
	  'apiVersion': 'monitoring.coreos.com/v1',
	  'kind': 'ServiceMonitor',
	  'metadata': {
	    'labels': {
	      'app': app.name,
	    },
	    'name': app.name,
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
	        'app': app.name,
	      }
	    }
	  }
	};

	serviceMonitor