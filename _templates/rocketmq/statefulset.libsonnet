local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  local rocketmqExporterContainer = {
    name: 'rocketmq-expoter',
    image: clusterParams.registry + '/docker.io/apache/rocketmq-exporter:0.0.2',
    imagePullPolicy: app.imagePullPolicy,
    ports: [{name: 'metrics', containerPort: 5557}],
  };

  local nameSrvStatefulSet = [
	  {
	      apiVersion: 'apps/v1',
	      kind: 'StatefulSet',
	      metadata: {
	        name: app.name + '-namesrv-' + i,
	        labels: {app: app.name + '-namesrv-' + i},
	      },
	      spec: {
	        serviceName: app.name,
	        replicas: 1,
	        selector: {matchLabels: {app: app.name + '-namesrv-' + i}},
	        template: {
	          metadata: {
	            labels: {app: app.name + '-namesrv-' + i},
	          },
	          spec: {
	            imagePullSecrets: clusterParams.imagePullSecrets,
	            containers: [
	              {
	                name: 'namesrv',
	                image: app.image,
	                imagePullPolicy: app.imagePullPolicy,
	                env: app.nameSrv.env,
	                command: ['./mqnamesrv'],
	                ports: [{name: 'namesrv', containerPort: 9876}],
	                resources: app.nameSrv.resources,
	                volumeMounts: [
	                  {name: 'logs', mountPath: '/home/rocketmq/logs'},
	                ],
	              }, rocketmqExporterContainer
	            ],
	            volumes: [
	              {name: 'logs', persistentVolumeClaim: {claimName: 'logs-' + app.name + '-namesrv-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.nameSrv.replicas-1)
    ];

  local brokerStatefulSet = [
    {
      apiVersion: 'apps/v1',
      kind: 'StatefulSet',
      metadata: {
        name: app.name + '-' + i.name,
        labels: {app: app.name + '-' + i.name},
      },
      spec: {
        serviceName: app.name + '-' + i.name,
        replicas: 1,
        selector: {matchLabels: {app: app.name + '-' + i.name}},
        template: {
          metadata: {
            labels: {app: app.name + '-' + i.name},
          },
          spec: {
            imagePullSecrets: clusterParams.imagePullSecrets,
            containers: [
              {
                name: 'broker',
                image: app.image,
                imagePullPolicy: app.imagePullPolicy,
                env: app.broker.env,
                command: ['./mqbroker'],
                args: [
                  '-c',
                  '../conf/broker.conf',
                ],
                ports: [
                  {name: 'fast',   containerPort: 10909},
                  {name: 'broker', containerPort: 10911},
                  {name: 'ha',     containerPort: 10912},
                ],
                resources: app.broker.resources,
                volumeMounts: [
	                  {name: 'data', mountPath: '/home/rocketmq/store'},
	                  {name: 'logs', mountPath: '/home/rocketmq/logs'},
	                  {name: 'conf', mountPath: '/home/rocketmq/rocketmq-%s/conf/broker.conf' % app.rocketmqVersion, subPath: 'broker.conf', readOnly: true},
                ],
              },
            ],
            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-' + i.name}},
	              {name: 'logs', persistentVolumeClaim: {claimName: 'logs-' + app.name + '-' + i.name}},
	              {name: 'conf', configMap: {name: app.name, items: [{key: i.configFile + '.conf', path: 'broker.conf'}]}},
            ],
          },
        },
      },
    }
    for i in [app.brokerM1, app.brokerS1, app.brokerM2, app.brokerS2]
  ];


  nameSrvStatefulSet + brokerStatefulSet
