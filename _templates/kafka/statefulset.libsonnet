local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  // KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
  local KAFKA_CONTROLLER_QUORUM_VOTERS = [
    i + 1 + '@' + app.name + '-controller-%s:9093' % i
    for i in std.range(0, app.controller.replicas-1)
  ];

  local controllerStatefulSet = [
	  {
	      apiVersion: 'apps/v1',
	      kind: 'StatefulSet',
	      metadata: {
	        name: app.name + '-controller-' + i,
	        labels: {app: app.name + '-controller-' + i},
	      },
	      spec: {
	        serviceName: app.name + '-controller-' + i,
	        replicas: 1,
	        selector: {matchLabels: {app: app.name + '-controller-' + i}},
	        template: {
	          metadata: {
	            labels: {app: app.name + '-controller-' + i},
	          },
	          spec: {
	            imagePullSecrets: clusterParams.imagePullSecrets,
	            containers: [
	              {
	                name: 'controller',
	                image: app.image,
	                imagePullPolicy: app.imagePullPolicy,
	                env: app.controller.env + [
	                  {name: 'CLUSTER_ID', value: app.clusterID},
	                  {name: 'KAFKA_NODE_ID', value: '%d' % [i + 1]},
	                  {name: 'KAFKA_CONTROLLER_QUORUM_VOTERS', value: std.join(",", KAFKA_CONTROLLER_QUORUM_VOTERS)},
	                  {name: 'KAFKA_LOG_DIRS', value: app.kafkaDataDir},
	                ]
	                ,
	                ports: [{name: 'controller', containerPort: 9093}],
	                resources: app.controller.resources,
	                volumeMounts: [
	                  {name: 'data', mountPath: app.kafkaDataDir},
	                ],
	              },
	            ],
	            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-controller-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.controller.replicas-1)
    ];

  local brokerStatefulSet = [
	  {
	      apiVersion: 'apps/v1',
	      kind: 'StatefulSet',
	      metadata: {
	        name: app.name + '-broker-' + i,
	        labels: {app: app.name + '-broker-' + i},
	      },
	      spec: {
	        serviceName: app.name + '-broker-' + i,
	        replicas: 1,
	        selector: {matchLabels: {app: app.name + '-broker-' + i}},
	        template: {
	          metadata: {
	            labels: {app: app.name + '-broker-' + i},
	          },
	          spec: {
	            imagePullSecrets: clusterParams.imagePullSecrets,
	            containers: [
	              {
	                name: 'broker',
	                image: app.image,
	                imagePullPolicy: app.imagePullPolicy,
	                env: app.broker.env + [
                    {name: 'CLUSTER_ID', value: app.clusterID},
	                  {name: 'KAFKA_NODE_ID', value: '%d' % [i + app.controller.replicas + 1]},
	                  {name: 'KAFKA_CONTROLLER_QUORUM_VOTERS', value: std.join(",", KAFKA_CONTROLLER_QUORUM_VOTERS)},
	                  {name: 'KAFKA_ADVERTISED_LISTENERS', value: 'PLAINTEXT://%s-broker-%d:19092,PLAINTEXT_HOST://%s-broker-%d:9092' % [app.name, i, app.name, i]},
	                  {name: 'KAFKA_LOG_DIRS', value: app.kafkaDataDir},
	                ]
	                ,
	                ports: [
	                  {name: 'broker', containerPort: 9092},
	                  {name: 'broker-internal', containerPort: 19092},
	                ],
	                resources: app.broker.resources,
	                volumeMounts: [
	                  {name: 'data', mountPath: app.kafkaDataDir},
	                ],
	              },
	            ],
	            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-broker-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.controller.replicas-1)
    ];

    controllerStatefulSet + brokerStatefulSet
