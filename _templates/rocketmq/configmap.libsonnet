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
	    'brokerM1.conf': std.get(configmapIndex, app.brokerM1.configFile)(app),
	    'brokerS1.conf': std.get(configmapIndex, app.brokerS1.configFile)(app),
	    'brokerM2.conf': std.get(configmapIndex, app.brokerM2.configFile)(app),
	    'brokerS2.conf': std.get(configmapIndex, app.brokerS2.configFile)(app),
	  }
	};

  [configmap]