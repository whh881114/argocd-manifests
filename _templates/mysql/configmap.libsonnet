local configmapIndex = import './configmapIndex.libsonnet';

function(app)
	local configmap = {
	  apiVersion: 'v1',
	  kind: 'ConfigMap',
	  metadata: {
	    name: app.name,
	    labels: {app: app.name},
	  },
	  data: {
	    'my.cnf': std.get(configmapIndex, app.configFile)
	  }
	};

  configmap