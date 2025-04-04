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
      'myid.sh': |||
        #!/bin/bash
        myid=`echo $HOSTNAME | awk -F '-' '{print $NF}'`
        myid=$[myid+1]
        echo $myid > /data/myid
      |||,

	    'zoo.cfg': std.get(configmapIndex, app.configFile)(app),
	  }
	};

  [configmap]