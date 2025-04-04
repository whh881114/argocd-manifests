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
	    'redis.conf': std.get(configmapIndex, app.configFile)(app)   // 调用default.libsonnet中的函数，实现动态处理。
	  }
	};

  configmap